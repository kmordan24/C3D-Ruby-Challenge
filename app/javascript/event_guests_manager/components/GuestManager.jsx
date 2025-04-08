import React, { useCallback, useEffect, useState } from "react";
import { addGuest, getGuestList } from "../utils";

// TODO: move styles to a CSS file
export const GuestManager = () => {
  const [guests, setGuests] = useState([]);
  const [newGuest, setNewGuest] = useState({ name: "", email: "" });
  const [error, setError] = useState(null);
  const mountedRef = React.useRef(false);

  // The mountedRef is 99% unnecessary in this exercise, but demonstrates safe handling of
  // useEffect with async functions that would try to mutate state on a potentially unmounted component
  useEffect(() => {
    mountedRef.current = true;

    const fetchGuests = async () => {
      const nextGuestList = await getGuestList();
      if (nextGuestList && mountedRef.current) {
        setGuests(nextGuestList);
      }
    };

    fetchGuests();

    return () => {
      mountedRef.current = false;
    };
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewGuest((prev) => ({ ...prev, [name]: value }));
  };

  const handleAddGuest = useCallback(
    async (e) => {
      e.preventDefault();
      try {
        await addGuest(newGuest);
        const nextGuestList = await getGuestList();
        setNewGuest({ name: "", email: "" });
        setGuests(nextGuestList);
      } catch (e) {
        setError("An error occurred while adding the guest. Please try again.");
      }
    },
    [newGuest],
  );

  return (
    <form aria-labelledby="guest-manager-heading" onSubmit={handleAddGuest}>
      {error && (
        <div style={{ color: "red", marginBottom: "1rem" }}>{error}</div>
      )}
      {guests.map((guest, index) => (
        <div
          key={guest.id}
          className="guest-item"
          style={{
            position: "relative",
            display: "flex",
            marginBottom: "0.5rem",
          }}
        >
          <label
            htmlFor={`guest-name-${index}`}
            style={{
              visibility: "hidden",
              position: "absolute",
              top: "0",
              left: "0",
              width: "0%",
              height: "0%",
            }}
          >
            Name:
          </label>
          <input
            type="text"
            id={`guest-name-${index}`}
            name={`guest-name-${index}`}
            value={guest.name}
            aria-label={`Guest ${index + 1} name`}
            style={{ padding: "0.5rem 1rem", marginRight: "0.5rem" }}
            disabled
            readOnly
          />
          <label
            htmlFor={`guest-email-${index}`}
            style={{
              visibility: "hidden",
              position: "absolute",
              top: "0",
              left: "0",
              width: "0%",
              height: "0%",
            }}
          >
            Email:
          </label>
          <input
            type="email"
            id={`guest-email-${index}`}
            name={`guest-email-${index}`}
            value={guest.email}
            aria-label={`Guest ${index + 1} email`}
            style={{ padding: "0.5rem 1rem", marginRight: "0.5rem" }}
            disabled
            readOnly
          />
        </div>
      ))}
      <div
        className="guest-item"
        style={{
          position: "relative",
          display: "flex",
          marginBottom: "0.5rem",
        }}
      >
        <label
          htmlFor="new-guest-name"
          style={{
            visibility: "hidden",
            position: "absolute",
            top: "0",
            left: "0",
            width: "0%",
            height: "0%",
          }}
        >
          Name:
        </label>
        <input
          type="text"
          id="new-guest-name"
          name="name"
          value={newGuest.name}
          onChange={handleInputChange}
          aria-label="New guest name"
          placeholder="Enter guest name"
          style={{ padding: "0.5rem 1rem", marginRight: "0.5rem" }}
          required
        />
        <label
          htmlFor="new-guest-email"
          style={{
            visibility: "hidden",
            position: "absolute",
            top: "0",
            left: "0",
            width: "0%",
            height: "0%",
          }}
        >
          Email:
        </label>
        <input
          type="email"
          id="new-guest-email"
          name="email"
          value={newGuest.email}
          onChange={handleInputChange}
          aria-label="New guest email"
          placeholder="Enter email address"
          style={{ padding: "0.5rem 1rem", marginRight: "0.5rem" }}
          required
        />
        <button type="submit">Add</button>
      </div>
    </form>
  );
};
