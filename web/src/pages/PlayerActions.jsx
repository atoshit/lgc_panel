import React, { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { 
    faArrowLeft, 
    faUser, 
    faBriefcase, 
    faFingerprint, 
    faNetworkWired,
    faTriangleExclamation,
    faBan,
    faRightFromBracket,
    faUserShield,
    faGun,
    faLocationArrow,
    faArrowRightArrowLeft,
    faCopy,
    faBoxArchive,
    faMessage,
    faSnowflake,
    faBug,
    faKitMedical,
    faUserPlus,
    faUserSlash,
    faGasPump,
    faWrench,
    faTrash,
    faGaugeHigh,
    faPalette,
    faEye,
    faRightToBracket,
    faShield,
    faHeart,
    faDroplet,
    faUtensils,
    faHome,
    faHistory
} from '@fortawesome/free-solid-svg-icons';
import {
    faDiscord,
    faRedditAlien,
    faSteam
} from '@fortawesome/free-brands-svg-icons';
import { Menu } from '@headlessui/react';

function PlayerActions({ player, onBack }) {
    const [currentTab, setCurrentTab] = useState('main');

    if (!player) return null;

    const jobs = [
        { name: 'police', label: 'LSPD' },
        { name: 'ambulance', label: 'EMS' },
        { name: 'mechanic', label: 'Mécano' },
        // ... autres jobs
    ];

    const roles = [
        { name: 'admin', label: 'Administrateur' },
        { name: 'mod', label: 'Modérateur' },
        // ... autres rôles
    ];

    const gangs = [
        { name: 'ballas', label: 'Ballas' },
        { name: 'vagos', label: 'Vagos' },
        // ... autres gangs
    ];

    return (
        <div className="h-full flex flex-col">
            <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-4">
                    <button
                        onClick={onBack}
                        className="p-2 hover:bg-neutral-800 rounded-lg transition-colors"
                    >
                        <FontAwesomeIcon icon={faArrowLeft} className="text-neutral-400" />
                    </button>
                    <h2 className="text-xl font-semibold text-neutral-200">
                        Actions sur {player.steamName} [{player.id}]
                    </h2>
                </div>

                {/* Navigation par onglets */}
                <div className="flex gap-2">
                    <button
                        onClick={() => setCurrentTab('main')}
                        className={`px-3 py-1.5 rounded-lg transition-colors flex items-center gap-2 ${
                            currentTab === 'main' 
                                ? 'bg-neutral-700 text-neutral-200' 
                                : 'bg-neutral-800 text-neutral-400 hover:bg-neutral-700/50'
                        }`}
                    >
                        <FontAwesomeIcon icon={faHome} className="text-xs" />
                        <span className="text-sm">Principal</span>
                    </button>
                    <button
                        onClick={() => setCurrentTab('history')}
                        className={`px-3 py-1.5 rounded-lg transition-colors flex items-center gap-2 ${
                            currentTab === 'history' 
                                ? 'bg-neutral-700 text-neutral-200' 
                                : 'bg-neutral-800 text-neutral-400 hover:bg-neutral-700/50'
                        }`}
                    >
                        <FontAwesomeIcon icon={faHistory} className="text-xs" />
                        <span className="text-sm">Historique</span>
                    </button>
                </div>
            </div>

            {/* Contenu des onglets */}
            {currentTab === 'main' ? (
                <div className="flex gap-6">
                    <div className="w-1/3 space-y-4">
                        <div className="bg-neutral-800 rounded-lg p-4 space-y-3">
                            <h3 className="text-lg font-semibold text-neutral-200 border-b border-neutral-700 pb-2">
                                Informations du joueur
                            </h3>
                            
                            <div className="space-y-3">
                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faUser} className="w-5" />
                                    <div>
                                        <div className="text-sm text-neutral-400">Nom RP</div>
                                        <div>{player.name}</div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faBriefcase} className="w-5" />
                                    <div>
                                        <div className="text-sm text-neutral-400">Métier</div>
                                        <div>{player.job.label} - Grade {player.job.grade}</div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faFingerprint} className="w-5 flex-shrink-0" />
                                    <div className="min-w-0">
                                        <div className="text-sm text-neutral-400">License</div>
                                        <div className="text-sm font-mono truncate">{player.identifier}</div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faSteam} className="w-5 flex-shrink-0" />
                                    <div className="min-w-0">
                                        <div className="text-sm text-neutral-400">Steam ID</div>
                                        <div className="text-sm font-mono truncate">STEAM_0:1:123456789</div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faNetworkWired} className="w-5 flex-shrink-0" />
                                    <div className="min-w-0">
                                        <div className="text-sm text-neutral-400">Adresse IP</div>
                                        <div className="text-sm font-mono truncate">192.168.1.1</div>
                                    </div>
                                </div>

                                <div className="flex items-center gap-3 text-neutral-300">
                                    <FontAwesomeIcon icon={faDiscord} className="w-5 flex-shrink-0" />
                                    <div className="min-w-0">
                                        <div className="text-sm text-neutral-400">Discord ID</div>
                                        <div className="text-sm font-mono truncate">123456789123456789</div>
                                    </div>
                                </div>

                                {/* Séparateur */}
                                <div className="border-t border-neutral-700 pt-3">
                                    {/* Vie */}
                                    <div className="space-y-1">
                                        <div className="flex items-center justify-between text-sm">
                                            <div className="flex items-center gap-2 text-red-400">
                                                <FontAwesomeIcon icon={faHeart} className="text-xs" />
                                                <span>Vie</span>
                                            </div>
                                            <span className="text-neutral-400">100%</span>
                                        </div>
                                        <div className="h-1.5 bg-neutral-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-red-500 rounded-full" style={{ width: '100%' }}></div>
                                        </div>
                                    </div>

                                    {/* Armure */}
                                    <div className="space-y-1 mt-3">
                                        <div className="flex items-center justify-between text-sm">
                                            <div className="flex items-center gap-2 text-blue-400">
                                                <FontAwesomeIcon icon={faShield} className="text-xs" />
                                                <span>Armure</span>
                                            </div>
                                            <span className="text-neutral-400">100%</span>
                                        </div>
                                        <div className="h-1.5 bg-neutral-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-blue-500 rounded-full" style={{ width: '100%' }}></div>
                                        </div>
                                    </div>

                                    {/* Faim */}
                                    <div className="space-y-1 mt-3">
                                        <div className="flex items-center justify-between text-sm">
                                            <div className="flex items-center gap-2 text-orange-400">
                                                <FontAwesomeIcon icon={faUtensils} className="text-xs" />
                                                <span>Faim</span>
                                            </div>
                                            <span className="text-neutral-400">100%</span>
                                        </div>
                                        <div className="h-1.5 bg-neutral-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-orange-500 rounded-full" style={{ width: '100%' }}></div>
                                        </div>
                                    </div>

                                    {/* Soif */}
                                    <div className="space-y-1 mt-3">
                                        <div className="flex items-center justify-between text-sm">
                                            <div className="flex items-center gap-2 text-cyan-400">
                                                <FontAwesomeIcon icon={faDroplet} className="text-xs" />
                                                <span>Soif</span>
                                            </div>
                                            <span className="text-neutral-400">100%</span>
                                        </div>
                                        <div className="h-1.5 bg-neutral-700 rounded-full overflow-hidden">
                                            <div className="h-full bg-cyan-500 rounded-full" style={{ width: '100%' }}></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div className="flex-1">
                        <div className="space-y-4">
                            {/* Sanctions */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Sanctions</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <button className="px-3 py-1.5 bg-red-500/10 hover:bg-red-500/20 text-red-500 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faBan} className="text-xs" />
                                        Ban
                                    </button>
                                    <button className="px-3 py-1.5 bg-orange-500/10 hover:bg-orange-500/20 text-orange-500 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faTriangleExclamation} className="text-xs" />
                                        Warn
                                    </button>
                                    <button className="px-3 py-1.5 bg-yellow-500/10 hover:bg-yellow-500/20 text-yellow-500 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faRightFromBracket} className="text-xs" />
                                        Kick
                                    </button>
                                </div>
                            </div>

                            {/* Administration */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Administration</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <Menu as="div" className="relative">
                                        <Menu.Button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                            <FontAwesomeIcon icon={faBriefcase} className="text-xs" />
                                            Setjob
                                        </Menu.Button>
                                        <Menu.Items className="absolute left-0 mt-2 w-48 bg-neutral-900 rounded-lg shadow-lg border border-neutral-700 py-1 z-20">
                                            {jobs.map(job => (
                                                <Menu.Item key={job.name}>
                                                    {({ active }) => (
                                                        <button className={`w-full text-left px-4 py-2 text-sm ${active ? 'bg-neutral-800 text-neutral-200' : 'text-neutral-400'}`}>
                                                            {job.label}
                                                        </button>
                                                    )}
                                                </Menu.Item>
                                            ))}
                                        </Menu.Items>
                                    </Menu>

                                    <Menu as="div" className="relative">
                                        <Menu.Button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                            <FontAwesomeIcon icon={faGun} className="text-xs" />
                                            Setgang
                                        </Menu.Button>
                                        <Menu.Items className="absolute left-0 mt-2 w-48 bg-neutral-900 rounded-lg shadow-lg border border-neutral-700 py-1 z-20">
                                            {gangs.map(gang => (
                                                <Menu.Item key={gang.name}>
                                                    {({ active }) => (
                                                        <button className={`w-full text-left px-4 py-2 text-sm ${active ? 'bg-neutral-800 text-neutral-200' : 'text-neutral-400'}`}>
                                                            {gang.label}
                                                        </button>
                                                    )}
                                                </Menu.Item>
                                            ))}
                                        </Menu.Items>
                                    </Menu>

                                    <Menu as="div" className="relative">
                                        <Menu.Button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                            <FontAwesomeIcon icon={faUserShield} className="text-xs" />
                                            Setrole
                                        </Menu.Button>
                                        <Menu.Items className="absolute left-0 mt-2 w-48 bg-neutral-900 rounded-lg shadow-lg border border-neutral-700 py-1 z-20">
                                            {roles.map(role => (
                                                <Menu.Item key={role.name}>
                                                    {({ active }) => (
                                                        <button className={`w-full text-left px-4 py-2 text-sm ${active ? 'bg-neutral-800 text-neutral-200' : 'text-neutral-400'}`}>
                                                            {role.label}
                                                        </button>
                                                    )}
                                                </Menu.Item>
                                            ))}
                                        </Menu.Items>
                                    </Menu>
                                </div>
                            </div>

                            {/* Actions sur le joueur */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Actions sur le joueur</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faUserPlus} className="text-xs" />
                                        Revive
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faKitMedical} className="text-xs" />
                                        Heal
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faSnowflake} className="text-xs" />
                                        Freeze
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faUserSlash} className="text-xs" />
                                        Tuer
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faRedditAlien} className="text-xs" />
                                        Mettre en ped
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faEye} className="text-xs" />
                                        Spectate
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faShield} className="text-xs" />
                                        Mettre de l'armure
                                    </button>
                                </div>
                            </div>

                            {/* Téléportation */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Téléportation</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faLocationArrow} className="text-xs" />
                                        TP sur
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faLocationArrow} className="rotate-180 text-xs" />
                                        TP à moi
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faArrowRightArrowLeft} className="text-xs" />
                                        TP à
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faCopy} className="text-xs" />
                                        Copier les coordonnées
                                    </button>
                                </div>
                            </div>

                            {/* Actions sur le véhicule */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Actions sur le véhicule</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faGasPump} className="text-xs" />
                                        Mettre le plein
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faWrench} className="text-xs" />
                                        Réparer
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faTrash} className="text-xs" />
                                        Supprimer
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faGaugeHigh} className="text-xs" />
                                        Booster
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faPalette} className="text-xs" />
                                        Changer la couleur
                                    </button>
                                </div>
                            </div>

                            {/* Autres actions */}
                            <div className="space-y-2">
                                <h4 className="text-sm font-semibold text-neutral-400 uppercase">Autres actions</h4>
                                <div className="flex flex-wrap gap-1.5">
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faBoxArchive} className="text-xs" />
                                        Mettre dans un bucket
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faBoxArchive} className="rotate-180 text-xs" />
                                        Reset le bucket
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faRightToBracket} className="text-xs" />
                                        Rejoindre le bucket
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faMessage} className="text-xs" />
                                        Envoyer un message
                                    </button>
                                    <button className="px-3 py-1.5 bg-neutral-500/10 hover:bg-neutral-500/20 text-neutral-300 rounded-lg transition-colors flex items-center gap-1.5 text-sm">
                                        <FontAwesomeIcon icon={faBug} className="text-xs" />
                                        Debug
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            ) : (
                <div className="flex flex-col gap-6">
                    {/* Historique des sanctions */}
                    <div className="bg-neutral-800 rounded-lg p-4">
                        <h3 className="text-lg font-semibold text-neutral-200 border-b border-neutral-700 pb-2 mb-4 flex items-center gap-2">
                            <FontAwesomeIcon icon={faTriangleExclamation} />
                            Historique des sanctions
                        </h3>
                        <div className="space-y-3">
                            <div className="bg-neutral-700/50 rounded-lg p-3">
                                <div className="flex items-center justify-between mb-2">
                                    <div className="flex items-center gap-2 text-red-400">
                                        <FontAwesomeIcon icon={faBan} />
                                        <span className="font-semibold">Ban temporaire</span>
                                    </div>
                                    <span className="text-sm text-neutral-400">Il y a 2 jours</span>
                                </div>
                                <p className="text-sm text-neutral-300">Raison : Utilisation de cheats</p>
                                <p className="text-sm text-neutral-400 mt-1">Par: Administrateur</p>
                            </div>
                        </div>
                    </div>

                    {/* Historique des actions */}
                    <div className="bg-neutral-800 rounded-lg p-4">
                        <h3 className="text-lg font-semibold text-neutral-200 border-b border-neutral-700 pb-2 mb-4 flex items-center gap-2">
                            <FontAwesomeIcon icon={faHistory} />
                            Historique des actions
                        </h3>
                        <div className="space-y-3">
                            <div className="bg-neutral-700/50 rounded-lg p-3">
                                <div className="flex items-center justify-between mb-2">
                                    <div className="flex items-center gap-2 text-neutral-200">
                                        <FontAwesomeIcon icon={faBriefcase} />
                                        <span className="font-semibold">Changement de métier</span>
                                    </div>
                                    <span className="text-sm text-neutral-400">Il y a 1 heure</span>
                                </div>
                                <p className="text-sm text-neutral-300">LSPD - Grade 1</p>
                                <p className="text-sm text-neutral-400 mt-1">Par: Modérateur</p>
                            </div>

                            <div className="bg-neutral-700/50 rounded-lg p-3">
                                <div className="flex items-center justify-between mb-2">
                                    <div className="flex items-center gap-2 text-neutral-200">
                                        <FontAwesomeIcon icon={faUserPlus} />
                                        <span className="font-semibold">Revive</span>
                                    </div>
                                    <span className="text-sm text-neutral-400">Il y a 3 heures</span>
                                </div>
                                <p className="text-sm text-neutral-400">Par: Administrateur</p>
                            </div>

                            <div className="bg-neutral-700/50 rounded-lg p-3">
                                <div className="flex items-center justify-between mb-2">
                                    <div className="flex items-center gap-2 text-neutral-200">
                                        <FontAwesomeIcon icon={faLocationArrow} />
                                        <span className="font-semibold">Téléportation</span>
                                    </div>
                                    <span className="text-sm text-neutral-400">Il y a 5 heures</span>
                                </div>
                                <p className="text-sm text-neutral-300">Téléporté vers: Commissariat</p>
                                <p className="text-sm text-neutral-400 mt-1">Par: Modérateur</p>
                            </div>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

export default PlayerActions; 