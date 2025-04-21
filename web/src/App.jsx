import React, { useState, useEffect } from 'react';
import Sidebar from './components/Sidebar';
import Dashboard from './pages/Dashboard';
import Players from './pages/Players';
import Reports from './pages/Reports';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faTimes } from '@fortawesome/free-solid-svg-icons';

function App() {
  const [visible, setVisible] = useState(false);
  const [currentPage, setCurrentPage] = useState('dashboard');
  const [version, setVersion] = useState('');

  const closePanel = () => {
    setVisible(false);
    fetch('https://lgc_panel/closePanel', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({}),
    });
  };

  useEffect(() => {
    console.log('App mounted');
    
    window.addEventListener('message', function(event) {
      const data = event.data;
      console.log('Message reçu:', data);
      
      if (data.action === 'setVisible') {
        console.log('Setting visible to:', data.data.show);
        setVisible(data.data.show);
        if (data.data.version) {
          setVersion(data.data.version);
        }
      }
    });
  }, []);

  useEffect(() => {
    console.log('Visible state changed:', visible);
  }, [visible]);

  useEffect(() => {
    const handleKeyPress = (event) => {
      if (event.key === 'Escape' && visible) {
        closePanel();
      }
    };

    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, [visible]);

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />;
      case 'players':
        return <Players />;
      case 'reports':
        return <Reports />;
      default:
        return <Dashboard />;
    }
  };

  if (!visible) return null;

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      width: '100%',
      height: '100%',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      backgroundColor: 'rgba(0, 0, 0, 0.7)',
      zIndex: 9999
    }}>
      <div style={{
        position: 'relative',
        width: '1200px',
        height: '800px',
        backgroundColor: '#1a1a1a',
        display: 'flex',
        borderRadius: '10px',
        overflow: 'hidden',
        boxShadow: '0 0 30px rgba(0, 0, 0, 0.5)'
      }}>
        <Sidebar 
          onPageChange={setCurrentPage} 
          currentPage={currentPage}
          version={version}
        />
        <main style={{
          flex: 1,
          backgroundColor: '#222222',
          padding: '20px',
          position: 'relative',
          overflow: 'auto'
        }}>
          <button 
            onClick={closePanel}
            style={{
              position: 'absolute',
              top: '15px',
              right: '15px',
              background: 'none',
              border: 'none',
              color: '#9ca3af',
              cursor: 'pointer',
              padding: '5px',
              transition: 'color 0.2s'
            }}
          >
            <FontAwesomeIcon icon={faTimes} style={{ width: '20px', height: '20px' }} />
          </button>

          {renderPage()}
        </main>
      </div>
    </div>
  );
}

export default App; 