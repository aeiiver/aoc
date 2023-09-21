.headers on
.mode box

BEGIN TRANSACTION;

WITH
puzzle AS (
    SELECT
        *
        , lhs || ' | ' || rhs both
    FROM forreal
),
segments AS (
    SELECT       0 digit, 6 nb_segments
    UNION SELECT 1,       2
    UNION SELECT 2,       5
    UNION SELECT 3,       5
    UNION SELECT 4,       4
    UNION SELECT 5,       5
    UNION SELECT 6,       6
    UNION SELECT 7,       3
    UNION SELECT 8,       7
    UNION SELECT 9,       6
),
rhs AS (
    WITH _splits AS (
        SELECT
            ''           head
            , rhs || ' ' tail
            , both       orig
        FROM puzzle
        UNION ALL
        SELECT
            SUBSTR(tail, 0, INSTR(tail, ' '))
            , SUBSTR(tail, INSTR(tail, ' ') + LENGTH(' '))
            , orig
        FROM _splits WHERE tail != ''
    )
    SELECT orig, head digit FROM _splits
    WHERE head != ''
),
one AS (
    SELECT COUNT(*) one_answer FROM rhs
    WHERE LENGTH(digit) in (
        SELECT nb_segments FROM segments
        GROUP BY nb_segments HAVING COUNT(*) = 1
    )
),
lhs AS (
    WITH _splits AS (
        SELECT
            ''           head
            , lhs || ' ' tail
            , both       orig
        FROM puzzle
        UNION ALL
        SELECT
            SUBSTR(tail, 0, INSTR(tail, ' '))
            , SUBSTR(tail, INSTR(tail, ' ') + LENGTH(' '))
            , orig
        FROM _splits WHERE tail != ''
    )
    SELECT orig, head digit FROM _splits
    WHERE head != ''
),
two AS (
    WITH digits AS (
        WITH _digits AS (
            SELECT
                orig
                , digit
                , (
                    WITH chars AS (
                        WITH _chars AS (
                            SELECT
                                ''      head
                                , digit tail
                            UNION ALL
                            SELECT
                                SUBSTR(tail, 0, 2)
                                , SUBSTR(tail, 2)
                            FROM _chars WHERE tail != ''
                        )
                        SELECT head char FROM _chars
                        WHERE head != ''
                    ),
                    chars4 AS (
                        WITH _chars AS (
                            SELECT
                                ''      head
                                , digit tail
                            FROM lhs WHERE orig = L.orig AND LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 4)
                            UNION ALL
                            SELECT
                                SUBSTR(tail, 0, 2)
                                , SUBSTR(tail, 2)
                            FROM _chars WHERE tail != ''
                        )
                        SELECT head char FROM _chars
                        WHERE head != ''
                    )
                    SELECT COUNT(*) FROM (
                        SELECT char FROM chars
                        INTERSECT
                        SELECT char FROM chars4
                    )
                ) four_segments
                , (
                    WITH chars AS (
                        WITH _chars AS (
                            SELECT
                                ''      head
                                , digit tail
                            UNION ALL
                            SELECT
                                SUBSTR(tail, 0, 2)
                                , SUBSTR(tail, 2)
                            FROM _chars WHERE tail != ''
                        )
                        SELECT head char FROM _chars
                        WHERE head != ''
                    ),
                    chars1 AS (
                        WITH _chars AS (
                            SELECT
                                ''      head
                                , digit tail
                            FROM lhs WHERE orig = L.orig AND LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 1)
                            UNION ALL
                            SELECT
                                SUBSTR(tail, 0, 2)
                                , SUBSTR(tail, 2)
                            FROM _chars WHERE tail != ''
                        )
                        SELECT head char FROM _chars
                        WHERE head != ''
                    )
                    SELECT COUNT(*) = (SELECT nb_segments FROM segments WHERE digit = 1) FROM (
                        SELECT char FROM chars
                        INTERSECT
                        SELECT char FROM chars1
                    )
                ) includes_one
            FROM lhs L
        )
        SELECT
            orig
            , digit
            , (
                CASE
                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 1)
                THEN 1
                -- unique

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 4)
                THEN 4
                -- unique

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 7)
                THEN 7
                -- unique

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 8)
                THEN 8
                -- unique

                --- 5 segments ---

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 2)
                AND four_segments = 2
                THEN 2
                -- card(. AND '4') = 2

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 3)
                AND includes_one
                THEN 3
                -- card(. AND '1') = 2

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 5)
                THEN 5
                -- not one of the above

                --- 6 segments ---

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 0)
                AND four_segments = 3
                AND includes_one
                THEN 0
                -- card(. AND '4') = 3 AND card(. AND '1') = 2

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 6)
                AND four_segments = 3
                THEN 6
                -- card(. AND '4') = 3

                WHEN LENGTH(digit) = (SELECT nb_segments FROM segments WHERE digit = 9)
                THEN 9
                -- not one of the above
                END
            ) value
        FROM _digits
    ),
    lastrun AS (
        SELECT
            orig
            , value
            , R.digit rhs_digit
            , (
                WITH chars AS (
                    WITH _chars AS (
                        SELECT
                            ''        head
                            , R.digit tail
                        UNION ALL
                        SELECT
                            SUBSTR(tail, 0, 2)
                            , SUBSTR(tail, 2)
                        FROM _chars WHERE tail != ''
                    )
                    SELECT head char FROM _chars
                    WHERE head != ''
                    ORDER BY head
                )
                SELECT GROUP_CONCAT(char, '') FROM chars
            ) rhs_digit_sorted
            , D.digit
            , (
                WITH chars AS (
                    WITH _chars AS (
                        SELECT
                            ''        head
                            , D.digit tail
                        UNION ALL
                        SELECT
                            SUBSTR(tail, 0, 2)
                            , SUBSTR(tail, 2)
                        FROM _chars WHERE tail != ''
                    )
                    SELECT head char FROM _chars
                    WHERE head != ''
                    ORDER BY head
                )
                SELECT GROUP_CONCAT(char, '') FROM chars
            ) digit_sorted
            , GROUP_CONCAT(value, '') two_answer
        FROM rhs R
        INNER JOIN digits D USING (orig)
        WHERE R.orig = D.orig AND rhs_digit_sorted = digit_sorted
        GROUP BY orig
    )
    SELECT SUM(two_answer) FROM lastrun
)
SELECT
    (SELECT * FROM one) one,
    (SELECT * FROM two) two;

-- 369
-- 1031553

END TRANSACTION;

-- digits:   0 1 2 3 4 5 6 7 8 9
-- segments: 6 2 5 5 4 5 6 3 7 6

--   0:      1:      2:      3:      4:
--  aaaa    ....    aaaa    aaaa    ....
-- b    c  .    c  .    c  .    c  b    c
-- b    c  .    c  .    c  .    c  b    c
--  ....    ....    dddd    dddd    dddd
-- e    f  .    f  e    .  .    f  .    f
-- e    f  .    f  e    .  .    f  .    f
--  gggg    ....    gggg    gggg    ....
--
--   5:      6:      7:      8:      9:
--  aaaa    aaaa    aaaa    aaaa    aaaa
-- b    .  b    .  .    c  b    c  b    c
-- b    .  b    .  .    c  b    c  b    c
--  dddd    dddd    ....    dddd    dddd
-- .    f  e    f  .    f  e    f  .    f
-- .    f  e    f  .    f  e    f  .    f
--  gggg    gggg    ....    gggg    gggg
