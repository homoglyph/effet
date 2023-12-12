(local libs-dir (.. (os.getenv :HOME) "/lcl/share/lualibs/"))
(local cfg-dir  (.. (os.getenv :HOME) "/cfg/hilbish/"))

(set package.path (.. package.path ";" libs-dir "?.lua"))

(local fennel (require :fennel))
(set fennel.path  (.. fennel.path ";" cfg-dir ":?.fnl"))
(tset fennel :macro-path (.. cfg-dir "?.fnl;"))

(global searcher (fennel.makeSearcher {:allowedGlobals false
                                       :compilerEnv _G
                                       :correlate true
                                       :useMetadata true}))

(table.insert (or package.loaders package.searchers) searcher)
(set debug.traceback fennel.traceback)
(require :config)
