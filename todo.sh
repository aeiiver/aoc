#!/usr/bin/env sh

### Report unfinished challenges

# Basically this looks at the git log for commits prefixed with the day of the
# challenge (e.g.: "2022.03: <commit message>"). If an unfinished challenge is
# committed anyway, it shall have a star after the day but before the colon
# (e.g.: "2022.03*: <commit message>"). If the same challenge is committed
# without a star, it shall be considered as done.

git log --format=%s | awk '
# Funny date hack
/^20/ {
	reversed[++nr] = $0
}

END {
	for (i = nr; i >= 1; --i) {
		day = substr(reversed[i], 1, 7)
		is_done = substr(reversed[i], 8, 1)
		challenges[day] = is_done == ":" ? "done" : "TODO"
	}
	for (day in challenges) {
		print day, challenges[day]
	}
}' | sort
