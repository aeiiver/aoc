# This won't work...

function BuildWorryOp {
    param(
        [string]$op,
        [string]$rightOp
    )
    switch ($op) {
        "+" {
            if ($rightOp -eq "old") {
                return { param($item) Invoke-Expression "$item + $item" }
            }
            else {
                return { param($item) Invoke-Expression "$item + $rightOp" }
            }
        }
        "*" {
            if ($rightOp -eq "old") {
                return { param($item) Invoke-Expression "$item * $item" }
            }
            else {
                return { param($item) Invoke-Expression "$item * $rightOp" }
            }
        }
    }
    throw "Powershell 🤮"
}

$monkeys = [System.Collections.ArrayList]::new()

Get-Content -Delimiter "`r`n`r`n" "./day11.test" | ForEach-Object {

    $monkey = [pscustomobject]@{
        Items         = [System.Collections.ArrayList]::new();
        WorryOp       = $null;
        TestOp        = $null;
        TrueReceiver  = $null;
        FalseReceiver = $null;
        Inspections   = 0;
    }

    $_ -split "`r`n" | ForEach-Object {

        if ($_.StartsWith("  Starting items: ")) {
            $monkey.Items = [System.Collections.ArrayList]([int[]]($_.Substring("  Starting items: ".Length) -split ", "))
        }

        elseif ($_.StartsWith("  Operation: new = ")) {
            $left, $op, $right = $_.Substring("  Operation: new = ".Length) -split " "
            $monkey.WorryOp = BuildWorryOp $op $right
            $monkey.WorryOp.InvokeReturnAsIs(79)
        }

        elseif ($_.StartsWith("  Test: divisible by ")) {
            $divisor = [int]$_.Substring("  Test: divisible by ".Length)
            $monkey.TestOp = { param([int64]$item) $item % $divisor }
        }

        elseif ($_.StartsWith("    If true: throw to monkey ")) {
            $monkey.TrueReceiver = [int]$_.Substring("    If true: throw to monkey ".Length)
        }

        elseif ($_.StartsWith("    If false: throw to monkey ")) {
            $monkey.FalseReceiver = [int]$_.Substring("    If false: throw to monkey ".Length)
        }
    }

    $null = $monkeys.Add($monkey)
}

for ($i = 0; $i -lt 20; ++ $i) {

    $monkeys | ForEach-Object {
        $monkey = $_

        $_.Items | ForEach-Object {
            $inspectedItem = [int]$_
            $monkey.Items.RemoveAt(0)
            $monkey.Inspections += 1

            $worriedAsF = ($monkey.WorryOp.InvokeReturnAsIs($inspectedItem))
            $relieved = [math]::Round($worriedAsF / 3)
            $monkeyTest = $monkey.TestOp.InvokeReturnAsIs($relieved)

            # "$inspectedItem -> $($monkey.WorryOp.Invoke(79)) $worriedAsF -> $relieved"

            $receiver = if ($monkeyTest) { $monkey.TrueReceiver } else { $monkey.FalseReceiver }
            $null = $monkeys[$receiver].Items.Add($relieved)
        }
    }
    # ""
}

# $monkeys
