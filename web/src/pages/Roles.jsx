import React, { useState, useEffect } from 'react';
import { fetchNui } from '../utils/nui';
import { motion, AnimatePresence } from 'framer-motion';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCircleCheck, faCircleXmark } from '@fortawesome/free-solid-svg-icons';

function Roles() {
  const permissionsList = {
    'panel.access': 'Accès au panel',
    'panel.players.view': 'Voir les joueurs',
    'panel.players.kick': 'Expulser les joueurs',
    'panel.players.ban': 'Bannir les joueurs',
    'panel.reports.view': 'Voir les reports',
    'panel.reports.manage': 'Gérer les reports',
    'panel.roles.manage': 'Gérer les rôles'
  };

  const defaultPermissions = Object.keys(permissionsList).reduce((acc, key) => {
    acc[key] = false;
    return acc;
  }, {});

  const [roles, setRoles] = useState([]);
  const [newRole, setNewRole] = useState({ 
    name: '', 
    label: '',
    permissions: defaultPermissions 
  });
  const [showCreateForm, setShowCreateForm] = useState(false);

  useEffect(() => {
    loadRoles();

    window.addEventListener('message', function(event) {
        if (event.data.action === 'reloadRoles') {
            loadRoles();
        }
    });
  }, []);

  const loadRoles = async () => {
    const response = await fetchNui('getRoles');
    console.log('Roles response:', response); 
    if (response?.success) {
      setRoles(response.data);
    }
  };

  const handleCreateRole = async () => {
    if (!newRole.name.trim() || !newRole.label.trim()) return;
    const response = await fetchNui('createRole', newRole);
    if (response?.success) {
      loadRoles();
      setNewRole({ 
        name: '', 
        label: '', 
        permissions: defaultPermissions 
      });
      setShowCreateForm(false);
    }
  };

  const handleDeleteRole = async (name) => {
    const response = await fetchNui('deleteRole', { name });
    if (response?.success) {
      loadRoles();
    }
  };

  const PermissionIcon = ({ enabled }) => (
    <FontAwesomeIcon 
      icon={enabled ? faCircleCheck : faCircleXmark}
      style={{
        color: enabled ? 'rgba(74, 222, 128, 0.8)' : 'rgba(239, 68, 68, 0.5)',
        width: '16px',
        marginRight: '10px',
        transition: 'all 0.2s ease'
      }}
    />
  );

  const formatDate = (timestamp) => {
    return new Date(timestamp).toLocaleString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="p-6 space-y-6 overflow-y-auto" style={{ height: '100%' }}>
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold text-neutral-200">Gestion des Rôles</h2>
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          className="bg-neutral-800 text-neutral-200 px-4 py-2 rounded-lg shadow-lg hover:bg-neutral-700 transition-colors"
          onClick={() => setShowCreateForm(!showCreateForm)}
        >
          {showCreateForm ? 'Annuler' : 'Nouveau Rôle'}
        </motion.button>
      </div>

      <AnimatePresence>
        {showCreateForm && (
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            className="bg-neutral-900 rounded-lg p-6 shadow-xl border border-neutral-800"
          >
            <h3 className="text-lg font-semibold text-neutral-200 mb-4">Créer un nouveau rôle</h3>
            <div className="space-y-4">
              <input
                type="text"
                value={newRole.name}
                onChange={(e) => setNewRole({ ...newRole, name: e.target.value })}
                placeholder="Identifiant du rôle (ex: mod)"
                className="w-full bg-neutral-800 text-neutral-200 px-4 py-2 rounded-lg focus:ring-2 focus:ring-neutral-700 outline-none border border-neutral-700"
              />
              <input
                type="text"
                value={newRole.label}
                onChange={(e) => setNewRole({ ...newRole, label: e.target.value })}
                placeholder="Nom affiché (ex: Modérateur)"
                className="w-full bg-neutral-800 text-neutral-200 px-4 py-2 rounded-lg focus:ring-2 focus:ring-neutral-700 outline-none border border-neutral-700"
              />
              <div className="grid grid-cols-2 gap-4">
                {Object.entries(permissionsList).map(([key, label]) => (
                  <label key={key} className="flex items-center space-x-2 text-neutral-400 hover:text-neutral-200 transition-colors">
                    <input
                      type="checkbox"
                      checked={newRole.permissions[key] || false}
                      onChange={(e) => setNewRole({
                        ...newRole,
                        permissions: { ...newRole.permissions, [key]: e.target.checked }
                      })}
                      className="custom-checkbox"
                    />
                    <span>{label}</span>
                  </label>
                ))}
              </div>
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={handleCreateRole}
                className="w-full bg-neutral-800 text-neutral-200 py-2 rounded-lg hover:bg-neutral-700 transition-colors"
              >
                Créer le rôle
              </motion.button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="grid grid-cols-2 gap-6">
        {roles.map((role) => (
          <motion.div
            key={role.name}
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-neutral-900 rounded-lg overflow-hidden shadow-xl border border-neutral-800"
          >
            <div className="p-4 bg-neutral-800">
              <div className="flex justify-between items-center">
                <div>
                  <h3 className="text-lg font-semibold text-neutral-200">{role.label}</h3>
                  <span className="text-sm text-neutral-400">{role.name}</span>
                </div>
                <div className="space-x-2">
                  {role.name !== 'admin' && (
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => handleDeleteRole(role.name)}
                      className="px-3 py-1 bg-neutral-700 text-neutral-200 rounded-md hover:bg-neutral-600 transition-colors"
                    >
                      Supprimer
                    </motion.button>
                  )}
                </div>
              </div>
            </div>
            <div className="p-4">
              <div className="grid grid-cols-2 gap-2">
                {Object.entries(permissionsList).map(([key, label]) => (
                  <div key={key} 
                    className="flex items-center text-neutral-400 py-1 px-2 rounded hover:bg-neutral-800 transition-colors"
                    style={{ cursor: 'default' }}
                  >
                    <PermissionIcon enabled={role.permissions[key]} />
                    <span className="truncate">{label}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="px-4 py-2 bg-neutral-800 bg-opacity-50 text-xs text-neutral-500 border-t border-neutral-800">
              <div className="flex items-center justify-center space-x-3">
                <span>Créé par {role.created_by_name}</span>
                <span>•</span>
                <span>{formatDate(role.created_at)}</span>
              </div>
            </div>
          </motion.div>
        ))}
      </div>
    </div>
  );
}

export default Roles; 