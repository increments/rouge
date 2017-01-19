# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    # Ported straight from pygments-2.0pre, which is vendored with pygments.rb-0.6.0.
    class Batch < RegexLexer
      title "Batchfile"
      desc "DOS/Windows Batch file"

      tag 'batch'
      aliases 'bat', 'cmd', 'dosbatch', 'winbatch'
      filenames '*.bat', '*.cmd'

      state :root do
        # Lines can start with @ to prevent echo
        rule /^\s*@/mi, Punctuation
        rule /^(\s*)(rem\s.*)$/mi do
          groups Text, Comment
        end
        rule /".*?"/mi, Str::Double
        rule /'.*?'/mi, Str::Single
        # If made more specific, make sure you still allow expansions
        # like %~$VAR:zlt
        rule /%%?[~$:\w]+%?/mi, Name::Variable
        rule /::.*/mi, Comment # Technically :: only works at BOL
        rule /\b(set)(\s+)(\w+)/mi do
          groups Keyword, Text, Name::Variable
        end
        rule /\b(call)(\s+)(:\w+)/mi do
          groups Keyword, Text, Name::Label
        end
        rule /\b(goto)(\s+)(\w+)/mi do
          groups Keyword, Text, Name::Label
        end
        # Porter's NOTE:
        # \b at the beginning of the patten has no effect in Rouge.
        # So this rule can match in the middle of a bare word.
        rule /\b(set|call|echo|on|off|endlocal|for|do|goto|if|pause|
          setlocal|shift|errorlevel|exist|defined|cmdextversion|
          errorlevel|else|cd|md|del|deltree|cls|choice)\b/mix, Keyword
        # Porter's NOTE: Ditto.
        rule /\b(equ|neq|lss|leq|gtr|geq)\b/, Operator
        mixin :basic
        rule /./mi, Text
      end

      # Porter's NOTE: This state seems never be entered.
      state :echo do
        # Escapes only valid within echo args?
        rule /\^\^|\^<|\^>|\^\|/mi, Str::Escape
        rule /\n/mi, Text, :pop!
        mixin :basic
        rule /[^\'"^]+/, Text
      end

      state :basic do
        rule /".*?"/mi, Str::Double
        rule /'.*?'/mi, Str::Single
        rule /`.*?`/mi, Str::Backtick
        rule /-?\d+/mi, Num
        rule /,/mi, Punctuation
        rule %r(=)mi, Operator
        rule %r(/\S+)mi, Name
        rule /:\w+/mi, Name::Label
        rule /\w:\w+/mi, Text
        rule /([<>|])(\s*)(\w+)/ do
          groups Punctuation, Text, Name
        end
      end
    end
  end
end
