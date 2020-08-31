import React, { useState, Fragment } from "react";
import { useParams } from "react-router";
import useSWR from "swr";
import marked from "marked";
import { fetchEvent } from "../contentful/client";
import ErrorComponent from "../components/ErrorComponent";
import LoadingComponent from "../components/LoadingComponent";
import Image from "react-image-fade-in";
import { IconContext } from "react-icons";
import dateFormat from "dateformat";
import { FaFacebook, FaMapMarkerAlt, FaClock } from "react-icons/fa";
import "./event.scss";

const formatStringDate = "dddd, d mmmm yyyy";
const formatStringTime = "h:MMtt";

const Event = () => {
  const { id } = useParams();
  const [loadingSlow, setLoadingSlow] = useState(false);
  const { data, error } = useSWR(id, fetchEvent, {
    onLoadingSlow: () => setLoadingSlow(true),
  });

  if (!data) {
    if (error) {
      console.error(error);
      return <ErrorComponent error={error} />;
    }
    return <LoadingComponent loadingSlow={loadingSlow} />;
  }

  const entry = data.entry.fields;

  document.title = "Preview — " + data.entry.fields.title;
  const parsedBody = marked(entry.body ?? "");

  function renderDates() {
    if (!entry.eventEndDate) {
      return <span>{dateFormat(entry.eventStartDate, formatStringDate)}</span>;
    }
    if (
      new Date(entry.eventStartDate).getDay() ===
      new Date(entry.eventEndDate).getDay()
    ) {
      return <span>{dateFormat(entry.eventStartDate, formatStringDate)}</span>;
    }
    return (
      <span>
        {dateFormat(entry.eventStartDate, formatStringDate)} to{" "}
        {dateFormat(entry.eventEndDate, formatStringDate)}
      </span>
    );
  }
  function renderTimes() {
    if (!entry.eventEndDate) {
      return <span>{dateFormat(entry.eventStartDate, formatStringTime)}</span>;
    }
    return (
      <span>
        {dateFormat(entry.eventStartDate, formatStringTime)} to{" "}
        {dateFormat(entry.eventEndDate, formatStringTime)}
      </span>
    );
  }

  return (
    <Fragment>
      <div className="e-main">
        <Image
          className="e-big-image"
          src={entry.images[0].fields.file.url + "?h=400&fm=webp&q=70"}
        />
        <h1 className="e-heading">{entry.title}</h1>
        <IconContext.Provider
          value={{
            color: "var(--accent-color)",
            style: { marginRight: "8px" },
          }}
        >
          <span className="e-meta">
            <span>{renderDates()}</span>
            {entry.eventVenue && (
              <span>
                <FaMapMarkerAlt /> {entry.eventVenue}
              </span>
            )}
            <span>
              <FaClock /> {renderTimes()}
            </span>
            <span>
              <a
                href={entry.facebookLink}
                rel="noopener noreferrer nofollow"
                target="_blank"
              >
                <FaFacebook /> View on Facebook
              </a>
            </span>
          </span>
        </IconContext.Provider>
        <div
          className="e-body"
          dangerouslySetInnerHTML={{ __html: parsedBody }}
        />
      </div>
    </Fragment>
  );
};

export default Event;
