import { useState, Fragment } from "react";
import { useRoute } from "wouter";
import useSWR from "swr";
import { fetchEvent } from "../contentful/client";
import ErrorComponent from "../components/ErrorComponent";
import LoadingComponent from "../components/LoadingComponent";
import { documentToReactComponents } from "@contentful/rich-text-react-renderer";
import { IconContext } from "react-icons";
import { format } from "date-fns/fp";
import { FaFacebook, FaMapMarkerAlt, FaClock } from "react-icons/fa";
import "./event.scss";

const formatDate = format("cccc, d MMMM yyyy");
const formatTime = format("p");

const Event = () => {
  const [, params] = useRoute("/event/:id");
  const [loadingSlow, setLoadingSlow] = useState(false);
  const { data, error } = useSWR(params ? params.id : "", fetchEvent, {
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
  const parsedStartDate = new Date(data.entry.fields.eventStartDate);
  const parsedEndDate = data.entry.fields.eventEndDate
    ? new Date(data.entry.fields.eventEndDate)
    : undefined;

  function renderDates() {
    if (
      typeof parsedEndDate !== "undefined" &&
      parsedEndDate.getDay() !== parsedStartDate.getDay()
    ) {
      return (
        <span>
          {formatDate(parsedStartDate)} to {formatDate(parsedEndDate)}
        </span>
      );
    } else {
      return <span>{formatDate(parsedStartDate)}</span>;
    }
  }

  function renderTimes() {
    if (typeof parsedEndDate === "undefined") {
      return <span>{formatTime(parsedStartDate)}</span>;
    } else {
      return (
        <span>
          {formatTime(parsedStartDate)} to {formatTime(parsedEndDate)}
        </span>
      );
    }
  }

  return (
    <Fragment>
      <div className="e-main">
        <img
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
        <div className="e-body">
          {documentToReactComponents(data.entry.fields.description)}
        </div>
      </div>
    </Fragment>
  );
};

export default Event;
