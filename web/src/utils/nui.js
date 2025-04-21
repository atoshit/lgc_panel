export const isEnvBrowser = () => !(window).invokeNative;

// Fonction pour émuler les événements NUI en développement
const mockEventListener = {
  removeEventListener() { }
};

// Gestionnaire d'événements NUI
export const onNuiEvent = (action, handler) => {
  const eventListener = (event) => {
    const { action: eventAction, data } = event.data;
    if (eventAction === action) {
      handler(data);
    }
  };

  window.addEventListener('message', eventListener);
  return () => window.removeEventListener('message', eventListener);
};

// Fonction pour envoyer des messages au client FiveM
export const fetchNui = async (eventName, data) => {
  if (isEnvBrowser()) return null;

  try {
    const resp = await fetch(`https://lgc_panel/${eventName}`, {
      method: 'post',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });
    return await resp.json();
  } catch (error) {
    return null;
  }
}; 