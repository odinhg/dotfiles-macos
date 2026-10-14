-- harper-ls: grammar and spelling. Understands Typst, so math, code and
-- #import arguments are skipped. Add words with <leader>ca on a flagged word;
-- use the workspace dictionary for thesis terms.
return {
  root_markers = { ".harper-dictionary.txt", "typst.toml", ".git" },
  settings = {
    ["harper-ls"] = {
      dialect = "American",
      diagnosticSeverity = "information",
      codeActions = { ForceStable = true },
      markdown = { IgnoreLinkTitle = true },
      linters = {
        -- Formal register
        AvoidContractions = true,
        OxfordComma = true,
        NoOxfordComma = false,
        -- Style rules that fight academic writing
        LongSentences = false,
        Hedging = false,
        SpelledNumbers = false,
        BoringWords = false,
        FillerWords = false,
        UseTitleCase = false,
        AvoidCurses = false,
        ToDoHyphen = false,
      },
    },
  },
}
