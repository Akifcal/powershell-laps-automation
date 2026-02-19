<#
.SYNOPSIS
    Create a new user for LAPS with a temporary random password.
    
.DESCRIPTION
    This script checks if a specified local user exists. If not, it generates a 
    complex random password and creates the user account configured for LAPS 
    management (PasswordNeverExpires, UserMayNotChangePassword).

.LICENSE
    Copyright (C) 2024  Ing. Akif Calhan
    This program is free software under the terms of the GNU General Public License v3.0.
#>

# Configuration
$User = "lapsadmin"
$Size = 30

# Check if user already exists
$existUser = Get-LocalUser -Name $User -ErrorAction SilentlyContinue

if (!$existUser) {
    try {
        # 1. Generate a guaranteed complex password
        $upper   = [char[]]"ABCDEFGHJKLMNPQRSTUVWXYZ" | Get-Random -Count 2
        $lower   = [char[]]"abcdefghijkmnopqrstuvwxyz" | Get-Random -Count 2
        $numbers = [char[]]"1234567890" | Get-Random -Count 2
        $special = [char[]]"!+@-$%&/()=?{}" | Get-Random -Count 2
        
        # Fill the remaining characters randomly
        $allChars = [char[]]"abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ1234567890!+@-$%&/()=?{}"
        $filler   = $allChars | Get-Random -Count ($Size - 8)
        
        # Shuffle the characters so the order isn't predictable
        $passwordChars = ($upper + $lower + $numbers + $special + $filler) | Get-Random -Count $Size
        $password = $passwordChars -join ""
        
        # 2. Convert to SecureString
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        
        # 3. Create User (created as enabled by default)
        New-LocalUser -Name $User `
                      -Password $securePassword `
                      -AccountNeverExpires `
                      -UserMayNotChangePassword `
                      -PasswordNeverExpires `
                      -ErrorAction Stop

        Write-Host "User '$User' created successfully with temporary complex password."
        exit 0  # Exit code 0 > success
    }
    catch {
        Write-Error "Failed to create user '$User'. Reason: $($_.Exception.Message)"
        exit 1  # Exit code 1 > failure during creation
    }
} else {
    Write-Host "User '$User' already exists. No remediation needed."
    exit 1  # Exit code 1 > failure (as requested, because user already exists)
}
