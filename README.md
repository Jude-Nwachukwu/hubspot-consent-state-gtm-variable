# HubSpot Consent State – GTM Variable Template (Unofficial)

A Google Tag Manager (GTM) Variable Custom Template designed to work with the **HubSpot Consent Banner**. This template helps you identify the consent states of individual users and configure whether certain tags should execute based on their preferences.

---

## 📦 How to Download & Import the Template

1. Download the `template.tpl` file from this repository.
2. In your GTM container, go to **Templates > Variable Templates**.
3. Click **New**, then click the 3-dot menu and select **Import**.
4. Choose the downloaded `template.tpl` file and save.

---

## ⚙️ How to Configure the Variable Template

After importing the template, configure the following fields:

- **Select Consent State Check Type**  
  Choose whether to check a **specific** consent category or **all** categories.

- **Select Consent Category**  
  (Only appears if “Specific Consent State” is selected)  
  Choose one of the following:  
  - Necessary  
  - Analytics  
  - Advertisement  
  - Functionality

- **Enable Optional Output Transformation**  
  Optionally transform consent values into custom output terms (like “granted”, “denied”, etc.).

- **HubSpot Consent State Value Transformation**  
  Configure how to transform:
  - `True` → e.g., granted / accept
  - `False` → e.g., denied / deny
  - Optionally convert `undefined` into a value (like denied)

---

## 💡 Use Cases

- **Consent-based Tag Blocking**  
  Block marketing and analytics tags (like Meta Pixel) unless a specific consent category is **granted**.

- **Conditionally Fire Tags Based on Consent**  
  Trigger marketing or advertising tags only if the user has provided **Advertisement** or/and **Analytics** consent when you don't want to use Consent Mode.

- **Send Consent Signals to Vendors**  
  Forward native consent signals to platforms that still require you to send a consent signal even when you implemented Google Consent Mode.

---

## 👨‍💻 Developed by Jude for [DumbData](https://www.dumbdata.co/)

This template was built with precision and love to make Hubspot consent-aware tracking effortless and privacy-respecting.

---

## 🔗 Useful Links

- 👉 Explore more **[DumbData GTM Custom Templates](https://dumbdata.co/gtm-custom-templates/)**  
- 📬 Have questions? **[Contact Us](https://dumbdata.co/contact-us/)**

---

## 📄 License

**Apache 2.0 License**


> Developed with ❤️ by **Jude Nwachukwu Onyejekwe** for **[DumbData](https://www.dumbdata.co/)**
