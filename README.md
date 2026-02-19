# Local LAPS User Provisioning Script

This PowerShell script automates the creation of a dedicated local administrator account on Windows clients. It is specifically designed to be deployed via **Group Policy (GPO) as a Startup Script** to provide a consistent management target for Microsoft LAPS (Local Administrator Password Solution).

## 🚀 Key Features

* **Automated Verification:** The script checks for the existence of the defined user during every system startup.
* **Secure Provisioning:** If the user is missing, it is created with a cryptographically random, 30-character initial password.
* **LAPS Optimized:** Configures the account with `PasswordNeverExpires` and `UserMayNotChangePassword` flags, ensuring LAPS can take over management without conflict.
* **Idempotency Check:** If the user already exists, the script exits without making changes to preserve the existing state.

## 🛠 Deployment & Implementation

To execute this script within an Active Directory environment, follow these steps:

1.  **Script Placement:** Save `create-new-user-for-laps.ps1` into the `Scripts\Startup` folder of your GPO (located in the SYSVOL share).
2.  **GPO Configuration:**
    * Navigate to: `Computer Configuration` > `Policies` > `Windows Settings` > `Scripts (Startup/Shutdown)`.
    * Open **Startup**.
    * Switch to the **PowerShell Scripts** tab.
    * Click **Add** and select the script from your GPO path.
3.  **Targeting:** Ensure the GPO is linked to the Organizational Units (OUs) containing the target computer objects.

## 📝 Configuration Variables

You can customize the following variables directly in the script:

| Variable | Description | Default Value |
| :--- | :--- | :--- |
| `$User` | The name of the local account to be created. | `lapsadmin` |
| `$size` | The length of the temporary initial password. | `30` |

## ⚖️ License

This project is licensed under the **GNU General Public License v3.0**. For more details, see the script header or visit [gnu.org/licenses](http://www.gnu.org/licenses).

---
**Copyright (c) 2024 Ing. Akif Calhan**
