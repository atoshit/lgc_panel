import { useState, useEffect } from 'react';

export function useStats() {
  const [stats, setStats] = useState({
    players: 0,
    vehicles: 0,
    jobs: 0,
    zones: 0
  });

  useEffect(() => {
    const handleMessage = (event) => {
      const data = event.data;
      
      if (data.action === 'updateStats') {
        setStats(data.data);
      }
    };

    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);

  return stats;
} 