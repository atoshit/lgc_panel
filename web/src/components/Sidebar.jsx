// 
//     https://github.com/atoshit/lgc_panel
//
//     Copyright © 2025 Logic. Studios <https://github.com/atoshit>
// 

import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { 
  faHome,
  faUsers,
  faTriangleExclamation
} from '@fortawesome/free-solid-svg-icons';

function Sidebar({ onPageChange, currentPage, version }) {
  const menuItems = [
    { id: 'dashboard', name: 'Dashboard', icon: faHome },
    { id: 'players', name: 'Joueurs', icon: faUsers },
    { id: 'reports', name: 'Reports', icon: faTriangleExclamation },
  ];

  return (
    <div style={{
      width: '250px',
      backgroundColor: '#141414',
      padding: '1.5rem 1rem',
      display: 'flex',
      flexDirection: 'column',
      height: '100%',
      position: 'relative'
    }}>
      <nav style={{
        display: 'flex',
        flexDirection: 'column',
        gap: '0.25rem'
      }}>
        {menuItems.map((item) => (
          <button
            key={item.id}
            onClick={() => onPageChange(item.id)}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '0.75rem',
              padding: '0.75rem 1rem',
              color: currentPage === item.id ? 'white' : '#9ca3af',
              backgroundColor: currentPage === item.id ? '#2a2a2a' : 'transparent',
              border: 'none',
              borderRadius: '6px',
              cursor: 'pointer',
              transition: 'all 0.2s',
              textAlign: 'left',
              width: '100%',
              fontSize: '0.9rem',
              fontWeight: currentPage === item.id ? '600' : 'normal'
            }}
          >
            <FontAwesomeIcon icon={item.icon} style={{ width: '1.25rem' }} />
            <span>{item.name}</span>
          </button>
        ))}
      </nav>

      <div style={{
        position: 'absolute',
        bottom: 0,
        left: 0,
        width: '100%',
        padding: '1rem',
        borderTop: '1px solid #333',
        color: '#666',
        fontSize: '0.8rem',
        textAlign: 'center',
        backgroundColor: '#141414'
      }}>
        <div>Développé par Logic. Studios</div>
        <div style={{ marginTop: '0.5rem' }}>{version || 'v0.0.1'}</div>
      </div>
    </div>
  );
}

export default Sidebar; 