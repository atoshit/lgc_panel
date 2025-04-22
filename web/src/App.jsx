import React, { useState, useEffect } from 'react';
import Sidebar from './components/Sidebar';
import Dashboard from './pages/Dashboard';
import Players from './pages/Players';
import Reports from './pages/Reports';
import Roles from './pages/Roles';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faTimes, faUser, faFlag, faBan } from '@fortawesome/free-solid-svg-icons';

function App() {
  const [visible, setVisible] = useState(false);
  const [currentPage, setCurrentPage] = useState('dashboard');
  const [version, setVersion] = useState('');
  const [playerInfo, setPlayerInfo] = useState({
    name: '',
    id: '',
    role: '',
    reports: 0,
    bans: 0
  });

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
    window.addEventListener('message', function(event) {
      const data = event.data;
      
      if (data.action === 'setVisible') {
        setVisible(data.data.show);
        if (data.data.version) {
          setVersion(data.data.version);
        }
        if (data.data.playerInfo) {
          setPlayerInfo(data.data.playerInfo);
        }
      }
    });
  }, []);

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
      case 'roles':
        return <Roles />;
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
        <div style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'column',
          backgroundColor: '#222222',
          position: 'relative'
        }}>
          <div style={{
            backgroundColor: '#1a1a1a',
            padding: '15px 20px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            borderBottom: '1px solid #333333'
          }}>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '20px'
            }}>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px'
              }}>
                <FontAwesomeIcon icon={faUser} style={{ color: '#9ca3af' }} />
                <span style={{ color: '#e5e7eb' }}>{playerInfo.name}</span>
                <span style={{ color: '#9ca3af' }}>(ID: {playerInfo.id})</span>
              </div>
              <div style={{
                backgroundColor: '#2a2a2a',
                padding: '4px 8px',
                borderRadius: '4px',
                color: '#e5e7eb'
              }}>
                {playerInfo.role}
              </div>
            </div>

            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '15px'
            }}>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                color: '#9ca3af'
              }}>
                <FontAwesomeIcon icon={faFlag} />
                <span>{playerInfo.reports} reports</span>
              </div>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                color: '#9ca3af'
              }}>
                <FontAwesomeIcon icon={faBan} />
                <span>{playerInfo.bans} bans</span>
              </div>
              <button 
                onClick={closePanel}
                style={{
                  background: 'none',
                  border: 'none',
                  color: '#9ca3af',
                  cursor: 'pointer',
                  padding: '5px',
                  transition: 'color 0.2s',
                  marginLeft: '10px'
                }}
              >
                <FontAwesomeIcon icon={faTimes} style={{ width: '20px', height: '20px' }} />
              </button>
            </div>
          </div>

          <main style={{
            flex: 1,
            overflow: 'auto',
            padding: '20px'
          }}>
            {renderPage()}
          </main>
        </div>
      </div>
    </div>
  );
}

export default App; 