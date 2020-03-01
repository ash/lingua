grammar CommentableLanguage {
    regex ws {
        <!ww> [
            | \s*
            | \s* <inline-comment> \s*
        ]
    }

    regex inline-comment {
        '/*' \s* .*? \s* '*/'
    }

    rule one-line-comment {
        '#' \N*
    }
}
