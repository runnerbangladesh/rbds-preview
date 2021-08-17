import { documentToReactComponents } from "@contentful/rich-text-react-renderer";
import { format } from "date-fns/fp";
import { Fragment, useState } from "react";
import { IconContext } from "react-icons";
import { FaClock, FaFacebook, FaMapMarkerAlt } from "react-icons/fa";
import useSWR from "swr";
import { useRoute } from "wouter";
import ErrorComponent from "../components/ErrorComponent";
import LoadingComponent from "../components/LoadingComponent";
import { fetchEvent } from "../contentful/client";
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

  document.title = "Preview — " + entry.title;
  const parsedStartDate = new Date(entry.eventStartDate);
  const parsedEndDate = entry.eventEndDate
    ? new Date(entry.eventEndDate)
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
          {documentToReactComponents(entry.description)}
        </div>
      </div>
    </Fragment>
  );
};

export default Event;
