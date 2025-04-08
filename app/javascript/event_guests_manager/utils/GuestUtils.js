export const getGuestList = async () => {
  try {
    const response = await fetch(`${window.location.pathname}/guests`);
    if (response.ok) {
      return response.json();
    } else {
      console.error("Failed to fetch guests");
    }
  } catch (error) {
    console.error("Error fetching guests:", error);
  }
};

// could have better error handling
export const addGuest = async ({ name, email }) => {
  try {
    const response = await fetch(`${window.location.pathname}/guests`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ name, email }),
    });
    if (!response.ok) {
      throw new Error("Failed to add guest");
    }
  } catch (error) {
    console.error("Error adding guest:", error);
    throw new Error("Failed to add guest");
  }
};
