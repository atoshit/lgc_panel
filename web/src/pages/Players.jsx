// 
//     https://github.com/atoshit/lgc_panel
//
//     Copyright © 2025 Logic. Studios <https://github.com/atoshit>
// 

import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSearch, faBriefcase, faStar, faFingerprint, faUser, faCopy, faChevronLeft, faChevronRight, faChevronDown } from '@fortawesome/free-solid-svg-icons';
import { toast } from 'react-toastify';
import { Menu } from '@headlessui/react'

const PLAYERS_PER_PAGE = 20;

function Players({ onPlayerSelect }) {
    const [players, setPlayers] = useState([]);
    const [filteredPlayers, setFilteredPlayers] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [search, setSearch] = useState('');
    const [filters, setFilters] = useState({
        role: '',
        job: ''
    });
    const [availableFilters, setAvailableFilters] = useState({
        roles: [],
        jobs: []
    });

    useEffect(() => {
        const fetchPlayers = () => {
            fetch('https://lgc_panel/getPlayers', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            });
        };

        const handleMessage = (event) => {
            const data = event.data;
            
            if (data.action === 'setPlayers') {
                setPlayers(data.players || []);
                
                const roles = [...new Set(data.players.map(p => p.role))].filter(Boolean);
                const jobs = [...new Set(data.players.map(p => p.job.name))];
                
                setAvailableFilters({
                    roles,
                    jobs
                });
            }
        };

        window.addEventListener('message', handleMessage);
        fetchPlayers();

        return () => {
            window.removeEventListener('message', handleMessage);
        };
    }, []);

    useEffect(() => {
        let result = [...players];

        if (filters.role) {
            result = result.filter(p => p.role === filters.role);
        }
        if (filters.job) {
            result = result.filter(p => p.job.name === filters.job);
        }

        if (search) {
            const searchLower = search.toLowerCase();
            result = result.filter(p => 
                p.steamName.toLowerCase().includes(searchLower) ||
                p.id.toString().includes(searchLower) ||
                p.name.toLowerCase().includes(searchLower) ||
                p.job.label.toLowerCase().includes(searchLower) ||
                p.job.name.toLowerCase().includes(searchLower) ||
                p.job.grade.toString().includes(searchLower) ||
                p.identifier.toLowerCase().includes(searchLower) ||
                (p.role && p.role.toLowerCase().includes(searchLower))
            );
        }

        setFilteredPlayers(result);
    }, [players, filters, search]);

    const totalPages = Math.ceil(filteredPlayers.length / PLAYERS_PER_PAGE);
    const currentPlayers = filteredPlayers.slice(
        (currentPage - 1) * PLAYERS_PER_PAGE,
        currentPage * PLAYERS_PER_PAGE
    );

    const copyToClipboard = async (text) => {
        try {
            await navigator.clipboard.writeText(text);
            toast.success('Texte copié !', {
                position: "top-right",
                autoClose: 2000,
                hideProgressBar: true,
                closeOnClick: true,
                pauseOnHover: true,
                draggable: true,
                progress: undefined,
                theme: "dark",
            });
        } catch (err) {
            const textArea = document.createElement('textarea');
            textArea.value = text;
            document.body.appendChild(textArea);
            textArea.select();
            try {
                document.execCommand('copy');
                toast.success('Texte copié !', {
                    position: "top-right",
                    autoClose: 2000,
                    hideProgressBar: true,
                    closeOnClick: true,
                    pauseOnHover: true,
                    draggable: true,
                    progress: undefined,
                    theme: "dark",
                });
            } catch (err) {
                toast.error('Impossible de copier le texte', {
                    position: "top-right",
                    autoClose: 2000,
                    hideProgressBar: true,
                    closeOnClick: true,
                    pauseOnHover: true,
                    draggable: true,
                    progress: undefined,
                    theme: "dark",
                });
            }
            document.body.removeChild(textArea);
        }
    };

    return (
        <div className="h-full flex flex-col">
            <div className="flex-1 overflow-auto pr-4">
                <div className="space-y-6 pb-20">
                    <div className="flex gap-4 items-center sticky top-0 bg-[#222222] py-4 z-10 -mr-4 pr-4">
                        <div className="relative flex-1">
                            <FontAwesomeIcon 
                                icon={faSearch} 
                                className="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-500" 
                            />
                            <input
                                type="text"
                                placeholder="Rechercher un joueur..."
                                className="w-full pl-10 pr-4 py-2.5 bg-neutral-800 rounded-lg border border-neutral-700 text-neutral-200 placeholder-neutral-500 outline-none focus:border-neutral-600 transition-colors"
                                value={search}
                                onChange={(e) => setSearch(e.target.value)}
                            />
                        </div>
                        
                        <Menu as="div" className="relative">
                            <Menu.Button className="px-4 py-2 bg-neutral-800 text-neutral-300 rounded-lg flex items-center gap-2 hover:bg-neutral-700 transition-colors">
                                {filters.role || 'Rôle'}
                                <FontAwesomeIcon icon={faChevronDown} className="w-3 h-3 text-neutral-500" />
                            </Menu.Button>
                            <Menu.Items className="absolute right-0 mt-2 w-48 bg-neutral-800 rounded-lg shadow-lg border border-neutral-700 py-1 z-20">
                                <Menu.Item>
                                    {({ active }) => (
                                        <button
                                            onClick={() => setFilters(f => ({ ...f, role: '' }))}
                                            className={`w-full text-left px-4 py-2 text-sm ${
                                                active ? 'bg-neutral-700 text-neutral-200' : 'text-neutral-400'
                                            }`}
                                        >
                                            Tous les rôles
                                        </button>
                                    )}
                                </Menu.Item>
                                {availableFilters.roles.map(role => (
                                    <Menu.Item key={role}>
                                        {({ active }) => (
                                            <button
                                                onClick={() => setFilters(f => ({ ...f, role }))}
                                                className={`w-full text-left px-4 py-2 text-sm ${
                                                    active ? 'bg-neutral-700 text-neutral-200' : 'text-neutral-400'
                                                }`}
                                            >
                                                {role}
                                            </button>
                                        )}
                                    </Menu.Item>
                                ))}
                            </Menu.Items>
                        </Menu>

                        <Menu as="div" className="relative">
                            <Menu.Button className="px-4 py-2 bg-neutral-800 text-neutral-300 rounded-lg flex items-center gap-2 hover:bg-neutral-700 transition-colors">
                                {filters.job || 'Métier'}
                                <FontAwesomeIcon icon={faChevronDown} className="w-3 h-3 text-neutral-500" />
                            </Menu.Button>
                            <Menu.Items className="absolute right-0 mt-2 w-48 bg-neutral-800 rounded-lg shadow-lg border border-neutral-700 py-1 z-20">
                                <Menu.Item>
                                    {({ active }) => (
                                        <button
                                            onClick={() => setFilters(f => ({ ...f, job: '' }))}
                                            className={`w-full text-left px-4 py-2 text-sm ${
                                                active ? 'bg-neutral-700 text-neutral-200' : 'text-neutral-400'
                                            }`}
                                        >
                                            Tous les métiers
                                        </button>
                                    )}
                                </Menu.Item>
                                {availableFilters.jobs.map(job => (
                                    <Menu.Item key={job}>
                                        {({ active }) => (
                                            <button
                                                onClick={() => setFilters(f => ({ ...f, job }))}
                                                className={`w-full text-left px-4 py-2 text-sm ${
                                                    active ? 'bg-neutral-700 text-neutral-200' : 'text-neutral-400'
                                                }`}
                                            >
                                                {job}
                                            </button>
                                        )}
                                    </Menu.Item>
                                ))}
                            </Menu.Items>
                        </Menu>
                    </div>

                    <div className="grid grid-cols-2 gap-x-8 gap-y-20">
                        {currentPlayers.map(player => (
                            <motion.div
                                key={player.id}
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                            >
                                <div className="p-4 bg-neutral-800 rounded-lg shadow-lg h-[250px] flex flex-col">
                                    <div 
                                        onClick={() => onPlayerSelect(player.id)}
                                        className="flex justify-between items-center cursor-pointer transition-colors hover:bg-neutral-700/50 -m-4 mb-0 p-4 rounded-t-lg"
                                    >
                                        <div>
                                            <h3 className="text-lg font-semibold text-neutral-200 truncate max-w-[200px]">
                                                {player.steamName} <span className="text-neutral-400">[{player.id}]</span>
                                            </h3>
                                        </div>
                                        {player.role && (
                                            <div className="px-3 py-1 bg-neutral-700 text-neutral-200 rounded-md">
                                                {player.role}
                                            </div>
                                        )}
                                    </div>

                                    <div className="-mx-4 mt-0 p-4 bg-neutral-900 flex-1">
                                        <div className="space-y-3">
                                            <div className="flex items-center justify-between">
                                                <div className="flex items-center gap-3 truncate">
                                                    <FontAwesomeIcon icon={faUser} className="text-neutral-400 w-4 h-4 flex-shrink-0" />
                                                    <span className="text-neutral-200 truncate">{player.name}</span>
                                                </div>
                                                <button 
                                                    onClick={() => copyToClipboard(player.name)}
                                                    className="p-1.5 text-neutral-500 hover:text-neutral-300 transition-colors flex-shrink-0"
                                                    title="Copier"
                                                >
                                                    <FontAwesomeIcon icon={faCopy} className="w-3.5 h-3.5" />
                                                </button>
                                            </div>

                                            <div className="flex items-center justify-between">
                                                <div className="flex items-center gap-3">
                                                    <FontAwesomeIcon icon={faBriefcase} className="text-neutral-400 w-4 h-4" />
                                                    <span className="text-neutral-200">Métier: {player.job.label}</span>
                                                </div>
                                                <button 
                                                    onClick={() => copyToClipboard(player.job.label)}
                                                    className="p-1.5 text-neutral-500 hover:text-neutral-300 transition-colors"
                                                    title="Copier"
                                                >
                                                    <FontAwesomeIcon icon={faCopy} className="w-3.5 h-3.5" />
                                                </button>
                                            </div>

                                            <div className="flex items-center justify-between">
                                                <div className="flex items-center gap-3">
                                                    <FontAwesomeIcon icon={faStar} className="text-neutral-400 w-4 h-4" />
                                                    <span className="text-neutral-200">Grade: {player.job.grade}</span>
                                                </div>
                                                <button 
                                                    onClick={() => copyToClipboard(player.job.grade.toString())}
                                                    className="p-1.5 text-neutral-500 hover:text-neutral-300 transition-colors"
                                                    title="Copier"
                                                >
                                                    <FontAwesomeIcon icon={faCopy} className="w-3.5 h-3.5" />
                                                </button>
                                            </div>

                                            <div className="flex items-center justify-between">
                                                <div className="flex items-center gap-3">
                                                    <FontAwesomeIcon icon={faFingerprint} className="text-neutral-400 w-4 h-4" />
                                                    <span className="text-neutral-200">{player.identifier}</span>
                                                </div>
                                                <button 
                                                    onClick={() => copyToClipboard(player.identifier)}
                                                    className="p-1.5 text-neutral-500 hover:text-neutral-300 transition-colors"
                                                    title="Copier"
                                                >
                                                    <FontAwesomeIcon icon={faCopy} className="w-3.5 h-3.5" />
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="-mx-4 -mb-4 py-2.5 px-4 bg-neutral-900/50 text-xs text-neutral-600 flex items-center justify-between">
                                        <span className="truncate">Créé par {player.steamName}</span>
                                        <span>Il y a 2 heures</span>
                                    </div>
                                </div>
                            </motion.div>
                        ))}
                    </div>
                </div>
            </div>

            <div className="flex-shrink-0 p-4 bg-[#222222] border-t border-neutral-800 -mr-4 pr-8">
                <div className="flex justify-center items-center gap-4">
                    <button
                        onClick={() => setCurrentPage(currentPage - 1)}
                        disabled={currentPage === 1}
                        className="px-4 py-2 bg-neutral-800 text-neutral-200 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-neutral-700 transition-colors flex items-center gap-2"
                    >
                        <FontAwesomeIcon icon={faChevronLeft} />
                        Précédent
                    </button>
                    
                    <span className="text-neutral-400">
                        Page {currentPage} sur {totalPages}
                    </span>

                    <button
                        onClick={() => setCurrentPage(currentPage + 1)}
                        disabled={currentPage === totalPages}
                        className="px-4 py-2 bg-neutral-800 text-neutral-200 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-neutral-700 transition-colors flex items-center gap-2"
                    >
                        Suivant
                        <FontAwesomeIcon icon={faChevronRight} />
                    </button>
                </div>
            </div>
        </div>
    );
}

export default Players; 