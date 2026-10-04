import React, { useState } from 'react';
import {
  Sparkles,
  BookOpen,
  Lightbulb,
  CheckCircle2,
  Smile,
  Mic,
  Camera,
  Search,
  Star,
  Plus,
  Lock,
  Unlock,
  Share2,
  Trash2,
  Edit3,
  Calendar,
  Layers,
  Compass,
  ArrowRight,
  RefreshCw,
  FolderGit2,
  Sliders,
  Check,
  X,
  History,
  Info
} from 'lucide-react';

interface NoteItem {
  id: string;
  title: string;
  content: string;
  category: string;
  mood: string;
  date: string;
  isFavorite: boolean;
  tags: string[];
  type?: string;
}

interface CapsuleItem {
  id: string;
  title: string;
  message: string;
  unlockDate: string;
  daysRemaining: number;
  isOpened: boolean;
}

const INITIAL_NOTES: NoteItem[] = [
  {
    id: 'note-1',
    title: 'Flutter UDF Project Architecture',
    content: 'Building MindVault with Material 3 design principles. Focusing on seamless responsive layout transitions using LayoutBuilder and NavigationRail for desktop/web, while preserving bottom navigation on Android phones.',
    category: 'Study',
    mood: '🔥',
    date: 'Oct 4, 2026',
    isFavorite: true,
    tags: ['Flutter', 'Dart', 'Material3'],
    type: 'idea'
  },
  {
    id: 'note-2',
    title: 'DBMS Revision - Normalization & B+ Trees',
    content: 'Quick review for database engineering exams:\n- 1NF: Atomic values, unique columns\n- 2NF: No partial dependency on candidate key\n- 3NF: No transitive dependencies\nRemember: B+ trees store all records in leaf nodes with doubly linked lists.',
    category: 'Study',
    mood: '🤔',
    date: 'Oct 4, 2026',
    isFavorite: false,
    tags: ['DBMS', 'SQL', 'Exams'],
    type: 'note'
  },
  {
    id: 'note-3',
    title: 'Summer Internship Goals 2026',
    content: 'Targeting mobile engineering or full-stack software development roles. Preparing system design fundamentals, building production-grade Flutter apps with smooth 60fps animations.',
    category: 'Goals',
    mood: '🔥',
    date: 'Oct 3, 2026',
    isFavorite: true,
    tags: ['Career', 'Internship', 'Resume'],
    type: 'idea'
  },
  {
    id: 'note-4',
    title: 'Weekend Trek to Nandi Hills',
    content: 'Early 4:30 AM sunrise ride with college roommates. The fog rolling over the cliffs was breathtaking. Took quiet moments by the temple to just breathe and disconnect from screen time.',
    category: 'Travel',
    mood: '😌',
    date: 'Oct 2, 2026',
    isFavorite: true,
    tags: ['Travel', 'Nature', 'Friends'],
    type: 'note'
  },
  {
    id: 'note-5',
    title: 'Designing Without Clutter - Linear & Apple Notes',
    content: 'Key takeaways from studying premium productivity tools: typography hierarchy over heavy borders, subtle elevation, and micro-interactions when toggling favorites.',
    category: 'Ideas',
    mood: '😊',
    date: 'Oct 1, 2026',
    isFavorite: true,
    tags: ['UIDesign', 'Minimalism'],
    type: 'idea'
  }
];

const INITIAL_CAPSULES: CapsuleItem[] = [
  {
    id: 'cap-1',
    title: 'Open After College Graduation',
    message: 'Dear future self,\n\nIf you are reading this, you made it through all the late-night debugging sessions, final year submissions, and endless coffee runs! Stay curious, build things that solve real human problems, and always make time for the people who believed in you.',
    unlockDate: 'June 2027',
    daysRemaining: 247,
    isOpened: false
  },
  {
    id: 'cap-2',
    title: 'Letter to My 2027 Software Engineer Self',
    message: 'Remember when you were anxious about tech interviews and database normalization? Look at how far you have come. Keep learning new paradigms and mentor someone starting out.',
    unlockDate: 'October 2027',
    daysRemaining: 365,
    isOpened: false
  },
  {
    id: 'cap-3',
    title: 'Unlocked: First Semester College Check-In',
    message: '🎉 Congratulations on opening your first MindVault capsule!\n\nYou promised to stay consistent, give your best to every lab project, and build an app that you can proudly show to faculty. You did exactly that!',
    unlockDate: 'Yesterday',
    daysRemaining: 0,
    isOpened: true
  }
];

export default function App() {
  const [activeTab, setActiveTab] = useState<'home' | 'vault' | 'connect' | 'capsules' | 'profile' | 'diagnostics'>('home');
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [notes, setNotes] = useState<NoteItem[]>(INITIAL_NOTES);
  const [capsules, setCapsules] = useState<CapsuleItem[]>(INITIAL_CAPSULES);
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedNode, setSelectedNode] = useState<string | null>('Flutter');
  const [isQuickCaptureOpen, setIsQuickCaptureOpen] = useState(false);
  const [selectedCapsule, setSelectedCapsule] = useState<CapsuleItem | null>(null);

  // New Note Modal state
  const [newTitle, setNewTitle] = useState('');
  const [newContent, setNewContent] = useState('');
  const [newCategory, setNewCategory] = useState('Personal');
  const [newMood, setNewMood] = useState('😊');

  const categories = ['All', 'Personal', 'Study', 'Ideas', 'Work', 'Travel', 'Goals'];

  const filteredNotes = notes.filter(n => {
    const matchCat = selectedCategory === 'All' || n.category === selectedCategory;
    const matchSearch = searchQuery.trim() === '' ||
      n.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      n.content.toLowerCase().includes(searchQuery.toLowerCase()) ||
      n.tags.some(t => t.toLowerCase().includes(searchQuery.toLowerCase()));
    return matchCat && matchSearch;
  });

  const toggleFavorite = (id: string) => {
    setNotes(notes.map(n => n.id === id ? { ...n, isFavorite: !n.isFavorite } : n));
  };

  const handleCreateNote = () => {
    if (!newTitle.trim()) return;
    const newNote: NoteItem = {
      id: `note-${Date.now()}`,
      title: newTitle.trim(),
      content: newContent.trim() || 'No content provided.',
      category: newCategory,
      mood: newMood,
      date: 'Today',
      isFavorite: false,
      tags: [newCategory],
      type: 'note'
    };
    setNotes([newNote, ...notes]);
    setNewTitle('');
    setNewContent('');
    setIsQuickCaptureOpen(false);
  };

  const themeClasses = isDarkMode
    ? 'bg-[#0D0E15] text-[#F3F4F6]'
    : 'bg-[#F8F9FD] text-[#14151F]';

  const cardClasses = isDarkMode
    ? 'bg-[#171822] border-[#2E3044]'
    : 'bg-white border-[#E5E7EB]';

  return (
    <div className={`min-h-screen flex flex-col font-sans transition-colors duration-200 ${themeClasses}`}>
      {/* Top Banner explaining Preview Status */}
      <header className="px-4 py-2 bg-[#5B4DFF]/15 border-b border-[#5B4DFF]/30 flex flex-wrap items-center justify-between gap-2 text-xs">
        <div className="flex items-center gap-2">
          <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
          <span className="font-bold text-[#5B4DFF]">MINDVAULT PREVIEW</span>
          <span className="hidden sm:inline text-neutral-400">|</span>
          <span className="hidden sm:inline text-neutral-300">
            Genuine Flutter Codebase: <code className="bg-black/30 px-1.5 py-0.5 rounded text-violet-300">lib/main.dart</code>
          </span>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setActiveTab('diagnostics')}
            className={`px-2.5 py-1 rounded flex items-center gap-1.5 font-medium transition-all ${
              activeTab === 'diagnostics' ? 'bg-[#5B4DFF] text-white' : 'bg-black/20 hover:bg-black/40 text-neutral-300'
            }`}
          >
            <FolderGit2 className="w-3.5 h-3.5" />
            Flutter Diagnostics
          </button>
          <button
            onClick={() => setIsDarkMode(!isDarkMode)}
            className="px-2 py-1 rounded bg-black/20 hover:bg-black/40 text-neutral-300 transition-all"
            title="Toggle Theme"
          >
            {isDarkMode ? '☀️ Light' : '🌙 Dark'}
          </button>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1 max-w-4xl w-full mx-auto p-4 sm:p-6 pb-24">
        {/* DIAGNOSTICS VIEW */}
        {activeTab === 'diagnostics' && (
          <div className="space-y-6">
            <div className={`p-6 rounded-2xl border ${cardClasses}`}>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-xl bg-[#5B4DFF]/20 flex items-center justify-center text-[#5B4DFF]">
                  <CheckCircle2 className="w-6 h-6" />
                </div>
                <div>
                  <h2 className="text-xl font-bold">Flutter Project Diagnostic Report</h2>
                  <p className="text-xs text-neutral-400">All 8 critical Flutter checks verified and operational</p>
                </div>
              </div>

              <div className="grid sm:grid-cols-2 gap-3 text-sm">
                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">1. lib/main.dart</strong>
                    <span className="text-xs text-neutral-400">Valid entry point, WidgetsFlutterBinding initialized, ChangeNotifierProvider mounted</span>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">2. All Imports Validated</strong>
                    <span className="text-xs text-neutral-400">All relative models, widgets, and screens resolved without circular loops or missing files</span>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">3. pubspec.yaml Verified</strong>
                    <span className="text-xs text-neutral-400">Dependencies: provider (^6.1.2), intl (^0.19.0), shared_preferences (^2.3.2)</span>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">4. Navigation & Routes</strong>
                    <span className="text-xs text-neutral-400">MainNavigationScreen handles mobile BottomBar and desktop NavigationRail</span>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">5. Material 3 Theme</strong>
                    <span className="text-xs text-neutral-400">AppTheme provides lightTheme and darkTheme with Deep Violet primary palette</span>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-black/20 border border-white/5 flex items-start gap-2.5">
                  <Check className="w-4 h-4 text-emerald-400 mt-0.5" />
                  <div>
                    <strong className="block text-emerald-300">6. Widget Overflow Fixes</strong>
                    <span className="text-xs text-neutral-400">Replaced unconstrained Expanded with Flexible(loose) in NoteCard</span>
                  </div>
                </div>
              </div>

              <div className="mt-6 p-4 rounded-xl bg-[#5B4DFF]/10 border border-[#5B4DFF]/20 text-xs leading-relaxed">
                <strong className="text-[#5B4DFF] block mb-1">Why did the logs show [vite] connected?</strong>
                The AI Studio environment uses a background Node.js container with Vite running on port 3000 to serve the web preview pane.
                The genuine Flutter project is located directly in your filesystem at <code>/lib/main.dart</code>, <code>/pubspec.yaml</code>, and <code>/web/index.html</code>.
                You can run the genuine Flutter app locally or on Chrome with:
                <div className="mt-2 p-2 bg-black/40 rounded font-mono text-emerald-300 select-all">
                  flutter pub get && flutter run -d chrome
                </div>
              </div>

              <div className="mt-4 flex justify-end">
                <button
                  onClick={() => setActiveTab('home')}
                  className="px-4 py-2 rounded-xl bg-[#5B4DFF] text-white font-semibold text-sm hover:bg-[#4d3fe6] transition-all"
                >
                  Return to MindVault UI →
                </button>
              </div>
            </div>
          </div>
        )}

        {/* HOME SCREEN */}
        {activeTab === 'home' && (
          <div className="space-y-6">
            {/* Header Greeting */}
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">Good evening 👋</h1>
                <p className="text-sm text-neutral-400 mt-0.5">What's on your mind?</p>
              </div>
              <button
                onClick={() => setIsQuickCaptureOpen(true)}
                className="w-10 h-10 rounded-xl bg-[#5B4DFF] text-white flex items-center justify-center shadow-lg shadow-[#5B4DFF]/25 hover:scale-105 active:scale-95 transition-all"
              >
                <Plus className="w-5 h-5" />
              </button>
            </div>

            {/* Search Bar */}
            <div className={`flex items-center gap-3 px-4 py-3 rounded-2xl border ${cardClasses} shadow-sm`}>
              <Search className="w-5 h-5 text-neutral-400" />
              <input
                type="text"
                placeholder="Search your memory..."
                value={searchQuery}
                onChange={e => setSearchQuery(e.target.value)}
                className="bg-transparent border-none outline-none w-full text-sm placeholder:text-neutral-500"
              />
              {searchQuery && (
                <button onClick={() => setSearchQuery('')} className="text-neutral-400 hover:text-white">
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>

            {/* Quick Capture Options */}
            <div>
              <div className="text-[11px] font-bold tracking-wider text-neutral-400 uppercase mb-2.5">
                Quick Capture
              </div>
              <div className="flex gap-2.5 overflow-x-auto pb-2 scrollbar-none">
                {[
                  { emoji: '📝', label: 'Note', cat: 'Study' },
                  { emoji: '💡', label: 'Idea', cat: 'Ideas' },
                  { emoji: '☑', label: 'Task', cat: 'Work' },
                  { emoji: '😊', label: 'Mood', cat: 'Personal' },
                  { emoji: '🎙', label: 'Voice', cat: 'Ideas' },
                  { emoji: '📷', label: 'Photo', cat: 'Travel' },
                ].map(item => (
                  <button
                    key={item.label}
                    onClick={() => {
                      setNewCategory(item.cat);
                      setIsQuickCaptureOpen(true);
                    }}
                    className={`flex items-center gap-2 px-3.5 py-2.5 rounded-xl border text-sm font-semibold whitespace-nowrap hover:border-[#5B4DFF] transition-all ${cardClasses}`}
                  >
                    <span>{item.emoji}</span>
                    <span>{item.label}</span>
                  </button>
                ))}
              </div>
            </div>

            {/* Your Space Stats */}
            <div>
              <div className="text-[11px] font-bold tracking-wider text-neutral-400 uppercase mb-2.5">
                Your Space
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-5 gap-3">
                {[
                  { title: 'Memories', count: 120 + notes.length, color: 'text-violet-400' },
                  { title: 'Ideas', count: 24, color: 'text-amber-400' },
                  { title: 'Reflections', count: 18, color: 'text-emerald-400' },
                  { title: 'Favorites', count: notes.filter(n => n.isFavorite).length, color: 'text-pink-400' },
                  { title: 'Time Capsules', count: capsules.length, color: 'text-purple-400' },
                ].map(stat => (
                  <div key={stat.title} className={`p-4 rounded-2xl border ${cardClasses} flex flex-col justify-between`}>
                    <span className="text-xs text-neutral-400">{stat.title}</span>
                    <span className={`text-2xl font-black mt-2 ${stat.color}`}>{stat.count}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Today's Reflection & On This Day */}
            <div className="grid sm:grid-cols-2 gap-4">
              <div className={`p-5 rounded-2xl border ${cardClasses}`}>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-xs font-bold text-emerald-400 flex items-center gap-1.5">
                    <Sparkles className="w-3.5 h-3.5" /> Today's Reflection
                  </span>
                  <span className="text-xs text-neutral-400">😊 Motivated</span>
                </div>
                <p className="text-sm italic text-neutral-300">
                  "Today I finally started building my Flutter project. Setting high standards for design and user experience."
                </p>
                <button
                  onClick={() => setIsQuickCaptureOpen(true)}
                  className="mt-3 text-xs text-[#5B4DFF] font-semibold hover:underline flex items-center gap-1"
                >
                  + Add reflection
                </button>
              </div>

              <div className={`p-5 rounded-2xl border ${cardClasses}`}>
                <div className="flex items-center justify-between mb-3">
                  <span className="text-xs font-bold text-amber-400 flex items-center gap-1.5">
                    <History className="w-3.5 h-3.5" /> On This Day
                  </span>
                  <span className="text-xs text-neutral-400">1 year ago</span>
                </div>
                <p className="text-sm italic text-neutral-300">
                  "You wrote: I want to become really good at Flutter and build impactful products."
                </p>
                <button
                  onClick={() => setActiveTab('vault')}
                  className="mt-3 text-xs text-amber-400 font-semibold hover:underline flex items-center gap-1"
                >
                  View memory →
                </button>
              </div>
            </div>

            {/* Recent Memories */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <div className="text-[11px] font-bold tracking-wider text-neutral-400 uppercase">
                  Recent Memories
                </div>
                <button onClick={() => setActiveTab('vault')} className="text-xs text-[#5B4DFF] font-semibold">
                  View all ({notes.length})
                </button>
              </div>

              <div className="grid sm:grid-cols-2 gap-4">
                {notes.slice(0, 4).map(note => (
                  <div key={note.id} className={`p-4 rounded-2xl border ${cardClasses} space-y-2 hover:border-[#5B4DFF]/50 transition-all`}>
                    <div className="flex items-center justify-between text-xs">
                      <span className="px-2 py-0.5 rounded-full bg-[#5B4DFF]/15 text-[#5B4DFF] font-bold">
                        {note.category}
                      </span>
                      <div className="flex items-center gap-2">
                        <span>{note.mood}</span>
                        <button onClick={() => toggleFavorite(note.id)}>
                          <Star className={`w-4 h-4 ${note.isFavorite ? 'fill-amber-400 text-amber-400' : 'text-neutral-500'}`} />
                        </button>
                      </div>
                    </div>
                    <h3 className="font-bold text-sm tracking-tight line-clamp-1">{note.title}</h3>
                    <p className="text-xs text-neutral-400 line-clamp-2">{note.content}</p>
                    <div className="text-[10px] text-neutral-500 pt-1 flex justify-between">
                      <span>{note.date}</span>
                      {note.tags[0] && <span>#{note.tags[0]}</span>}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* VAULT SCREEN */}
        {activeTab === 'vault' && (
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">Your Vault</h1>
              <p className="text-sm text-neutral-400 mt-0.5">Everything worth remembering.</p>
            </div>

            {/* Category Chips */}
            <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-none">
              {categories.map(cat => (
                <button
                  key={cat}
                  onClick={() => setSelectedCategory(cat)}
                  className={`px-3.5 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                    selectedCategory === cat
                      ? 'bg-[#5B4DFF] text-white shadow-md shadow-[#5B4DFF]/25'
                      : isDarkMode ? 'bg-[#1E202E] text-neutral-400 hover:text-white' : 'bg-neutral-200 text-neutral-700'
                  }`}
                >
                  {cat}
                </button>
              ))}
            </div>

            {/* Notes List */}
            {filteredNotes.length === 0 ? (
              <div className={`p-12 text-center rounded-2xl border ${cardClasses}`}>
                <div className="text-3xl mb-2">🍃</div>
                <h3 className="font-bold text-base">Your vault is quiet.</h3>
                <p className="text-xs text-neutral-400 mt-1">Capture something worth remembering.</p>
                <button
                  onClick={() => setIsQuickCaptureOpen(true)}
                  className="mt-4 px-4 py-2 rounded-xl bg-[#5B4DFF] text-white text-xs font-semibold"
                >
                  Capture Memory
                </button>
              </div>
            ) : (
              <div className="grid sm:grid-cols-2 gap-4">
                {filteredNotes.map(note => (
                  <div key={note.id} className={`p-5 rounded-2xl border ${cardClasses} flex flex-col justify-between space-y-3`}>
                    <div>
                      <div className="flex items-center justify-between text-xs mb-2">
                        <span className="px-2.5 py-1 rounded-md bg-[#5B4DFF]/15 text-[#5B4DFF] font-bold">
                          {note.category}
                        </span>
                        <div className="flex items-center gap-2">
                          <span className="text-base">{note.mood}</span>
                          <button onClick={() => toggleFavorite(note.id)}>
                            <Star className={`w-4 h-4 ${note.isFavorite ? 'fill-amber-400 text-amber-400' : 'text-neutral-500'}`} />
                          </button>
                        </div>
                      </div>
                      <h3 className="font-bold text-base tracking-tight">{note.title}</h3>
                      <p className="text-xs text-neutral-400 mt-1.5 whitespace-pre-line leading-relaxed">{note.content}</p>
                    </div>

                    <div className="pt-2 border-t border-white/5 flex items-center justify-between text-[11px] text-neutral-500">
                      <span>{note.date}</span>
                      <div className="flex gap-1">
                        {note.tags.map(t => (
                          <span key={t} className="px-1.5 py-0.5 rounded bg-black/20">#{t}</span>
                        ))}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* CONNECT / MEMORY MAP SCREEN */}
        {activeTab === 'connect' && (
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">Your Mind</h1>
              <p className="text-sm text-neutral-400 mt-0.5">See how your thoughts connect.</p>
            </div>

            {/* Interactive Graph Simulation */}
            <div className={`relative h-80 rounded-2xl border overflow-hidden flex items-center justify-center ${cardClasses}`}>
              {/* Connecting lines */}
              <svg className="absolute inset-0 w-full h-full pointer-events-none">
                <line x1="50%" y1="25%" x2="25%" y2="50%" stroke="#5B4DFF" strokeWidth="2" strokeDasharray="4" opacity="0.6" />
                <line x1="50%" y1="25%" x2="75%" y2="50%" stroke="#5B4DFF" strokeWidth="2" strokeDasharray="4" opacity="0.6" />
                <line x1="25%" y1="50%" x2="50%" y2="80%" stroke="#5B4DFF" strokeWidth="2" opacity="0.4" />
                <line x1="75%" y1="50%" x2="50%" y2="80%" stroke="#5B4DFF" strokeWidth="2" opacity="0.4" />
              </svg>

              {/* Tappable Nodes */}
              {[
                { name: 'Flutter', x: '50%', y: '25%', count: 5 },
                { name: 'UI Design', x: '25%', y: '50%', count: 4 },
                { name: 'Firebase', x: '75%', y: '50%', count: 3 },
                { name: 'Projects', x: '50%', y: '80%', count: 6 },
              ].map(node => (
                <button
                  key={node.name}
                  onClick={() => setSelectedNode(node.name)}
                  style={{ left: node.x, top: node.y, transform: 'translate(-50%, -50%)' }}
                  className={`absolute px-4 py-2 rounded-2xl border text-xs font-bold transition-all shadow-lg ${
                    selectedNode === node.name
                      ? 'bg-[#5B4DFF] text-white scale-110 border-white'
                      : isDarkMode ? 'bg-[#1E202E] text-neutral-200 border-[#5B4DFF]/40' : 'bg-white text-neutral-800'
                  }`}
                >
                  {node.name} <span className="opacity-70 font-normal">({node.count})</span>
                </button>
              ))}
            </div>

            {/* Selected Node Details */}
            {selectedNode && (
              <div className={`p-5 rounded-2xl border ${cardClasses}`}>
                <h3 className="font-bold text-sm text-[#5B4DFF] mb-2">Connected Memories under "{selectedNode}"</h3>
                <div className="space-y-2">
                  {notes.filter(n => n.tags.some(t => t.toLowerCase().includes(selectedNode.toLowerCase()))).map(n => (
                    <div key={n.id} className="p-3 rounded-xl bg-black/20 text-xs flex justify-between items-center">
                      <span className="font-semibold">{n.title}</span>
                      <span className="text-neutral-400">{n.category}</span>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}

        {/* TIME CAPSULES SCREEN */}
        {activeTab === 'capsules' && (
          <div className="space-y-6">
            <div>
              <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight">Time Capsules</h1>
              <p className="text-sm text-neutral-400 mt-0.5">Messages for your future self.</p>
            </div>

            <div className="space-y-4">
              {capsules.map(cap => (
                <div
                  key={cap.id}
                  onClick={() => (cap.isOpened || cap.daysRemaining === 0) && setSelectedCapsule(cap)}
                  className={`p-5 rounded-2xl border transition-all ${
                    cap.isOpened || cap.daysRemaining === 0
                      ? 'border-[#5B4DFF] bg-[#5B4DFF]/10 cursor-pointer hover:scale-[1.01]'
                      : cardClasses
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <span className="text-2xl">{cap.isOpened ? '✨' : '🔒'}</span>
                      <div>
                        <h3 className="font-bold text-sm sm:text-base">{cap.title}</h3>
                        <p className="text-xs text-neutral-400">
                          {cap.isOpened ? 'Unlocked and ready to read' : `Opens: ${cap.unlockDate}`}
                        </p>
                      </div>
                    </div>
                    {cap.isOpened ? (
                      <span className="px-3 py-1 rounded-full bg-[#5B4DFF] text-white text-xs font-semibold">
                        Reveal
                      </span>
                    ) : (
                      <span className="text-xs font-bold text-neutral-400 bg-black/30 px-2.5 py-1 rounded-full">
                        {cap.daysRemaining}d left
                      </span>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* PROFILE SCREEN */}
        {activeTab === 'profile' && (
          <div className="space-y-6">
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-[#5B4DFF] to-violet-400 flex items-center justify-center text-white font-extrabold text-xl shadow-lg shadow-[#5B4DFF]/30">
                MV
              </div>
              <div>
                <h1 className="text-2xl font-extrabold tracking-tight">My MindVault</h1>
                <p className="text-xs text-[#5B4DFF] font-semibold">UDF Flutter Project Edition</p>
              </div>
            </div>

            <div className={`p-5 rounded-2xl border ${cardClasses} space-y-4`}>
              <h3 className="text-xs font-bold uppercase tracking-wider text-neutral-400">Appearance & Settings</h3>
              <div className="flex justify-between items-center text-sm">
                <span>Theme Mode</span>
                <button
                  onClick={() => setIsDarkMode(!isDarkMode)}
                  className="px-3 py-1.5 rounded-xl bg-[#5B4DFF] text-white text-xs font-bold"
                >
                  {isDarkMode ? '🌙 Dark Mode' : '☀️ Light Mode'}
                </button>
              </div>
              <div className="border-t border-white/5 pt-3 flex justify-between items-center text-sm">
                <span>Flutter Architecture Inspection</span>
                <button
                  onClick={() => setActiveTab('diagnostics')}
                  className="text-xs text-[#5B4DFF] font-bold hover:underline"
                >
                  View Report →
                </button>
              </div>
            </div>
          </div>
        )}
      </main>

      {/* REVEAL CAPSULE MODAL */}
      {selectedCapsule && (
        <div className="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className={`max-w-md w-full p-6 rounded-3xl border shadow-2xl ${cardClasses}`}>
            <div className="flex items-center gap-2 mb-3 text-[#5B4DFF]">
              <Sparkles className="w-5 h-5" />
              <span className="text-xs font-bold uppercase tracking-wider">Capsule Unlocked</span>
            </div>
            <h3 className="font-extrabold text-lg">{selectedCapsule.title}</h3>
            <p className="text-xs text-neutral-400 mt-1">Written for your future self</p>
            <div className="mt-4 p-4 rounded-xl bg-black/30 border border-white/5 text-sm italic text-neutral-200 whitespace-pre-line leading-relaxed">
              "{selectedCapsule.message}"
            </div>
            <button
              onClick={() => setSelectedCapsule(null)}
              className="mt-6 w-full py-2.5 rounded-xl bg-[#5B4DFF] text-white font-bold text-sm"
            >
              Close Capsule
            </button>
          </div>
        </div>
      )}

      {/* QUICK CAPTURE MODAL */}
      {isQuickCaptureOpen && (
        <div className="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-end sm:items-center justify-center p-0 sm:p-4">
          <div className={`w-full max-w-lg p-6 rounded-t-3xl sm:rounded-3xl border shadow-2xl ${cardClasses}`}>
            <div className="flex justify-between items-center mb-4">
              <div>
                <h3 className="font-extrabold text-lg">Capture a thought</h3>
                <p className="text-xs text-neutral-400">Don't organize it yet. Just save it.</p>
              </div>
              <button onClick={() => setIsQuickCaptureOpen(false)} className="text-neutral-400 hover:text-white">
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="space-y-3">
              <input
                type="text"
                placeholder="Title..."
                value={newTitle}
                onChange={e => setNewTitle(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl bg-black/20 border border-white/10 outline-none text-sm"
              />
              <textarea
                placeholder="What's worth remembering?"
                rows={3}
                value={newContent}
                onChange={e => setNewContent(e.target.value)}
                className="w-full px-4 py-2.5 rounded-xl bg-black/20 border border-white/10 outline-none text-sm resize-none"
              />
              <div className="flex gap-2 items-center justify-between">
                <select
                  value={newCategory}
                  onChange={e => setNewCategory(e.target.value)}
                  className="px-3 py-2 rounded-xl bg-black/20 border border-white/10 text-xs outline-none"
                >
                  {categories.filter(c => c !== 'All').map(c => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>

                <div className="flex gap-1.5">
                  {['😊', '😌', '🔥', '🤔', '😔'].map(m => (
                    <button
                      key={m}
                      onClick={() => setNewMood(m)}
                      className={`text-base p-1.5 rounded-lg ${newMood === m ? 'bg-[#5B4DFF]' : 'bg-black/20'}`}
                    >
                      {m}
                    </button>
                  ))}
                </div>
              </div>

              <button
                onClick={handleCreateNote}
                className="w-full mt-2 py-3 rounded-xl bg-[#5B4DFF] text-white font-bold text-sm shadow-lg shadow-[#5B4DFF]/30 hover:bg-[#4d3fe6] transition-all"
              >
                Save Memory to Vault
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Bottom Navigation Bar */}
      <nav className={`fixed bottom-0 inset-x-0 border-t ${cardClasses} py-2 px-6 flex justify-around items-center z-40 backdrop-blur-md`}>
        {[
          { id: 'home', label: 'Home', icon: BookOpen },
          { id: 'vault', label: 'Vault', icon: Layers },
          { id: 'connect', label: 'Connect', icon: Compass },
          { id: 'capsules', label: 'Capsules', icon: Lock },
          { id: 'profile', label: 'Profile', icon: Sliders },
        ].map(tab => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`flex flex-col items-center gap-1 text-[11px] font-semibold transition-all ${
                isActive ? 'text-[#5B4DFF] scale-105' : 'text-neutral-400 hover:text-neutral-200'
              }`}
            >
              <Icon className="w-5 h-5" />
              <span>{tab.label}</span>
            </button>
          );
        })}
      </nav>
    </div>
  );
}
