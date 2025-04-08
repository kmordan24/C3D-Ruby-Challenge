import React, { useCallback, useEffect, useState } from "react";
import { addGuest, getGuestList } from "../utils";

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
      {error && <div className="guest-item-error">{error}</div>}
      {guests.map((guest, index) => (
        <div key={guest.id} className="guest-item">
          <label htmlFor={`guest-name-${index}`}>Name:</label>
          <input
            type="text"
            id={`guest-name-${index}`}
            name={`guest-name-${index}`}
            value={guest.name}
            aria-label={`Guest ${index + 1} name`}
            disabled
            readOnly
          />
          <label htmlFor={`guest-email-${index}`}>Email:</label>
          <input
            type="email"
            id={`guest-email-${index}`}
            name={`guest-email-${index}`}
            value={guest.email}
            aria-label={`Guest ${index + 1} email`}
            disabled
            readOnly
          />
        </div>
      ))}
      <div className="guest-item">
        <label htmlFor="new-guest-name">Name:</label>
        <input
          type="text"
          id="new-guest-name"
          name="name"
          value={newGuest.name}
          onChange={handleInputChange}
          aria-label="New guest name"
          placeholder="Enter guest name"
          required
        />
        <label htmlFor="new-guest-email">Email:</label>
        <input
          type="email"
          id="new-guest-email"
          name="email"
          value={newGuest.email}
          onChange={handleInputChange}
          aria-label="New guest email"
          placeholder="Enter email address"
          required
        />
        <button type="submit">Add</button>
      </div>
    </form>
  );
};
