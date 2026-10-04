# Apha New Cup 2 — Official Website

یک سایت تک‌صفحه‌ای آماده برای GitHub Pages با تم طلایی/مشکی.

## امکانات
- فارسی / English از تنظیمات و دکمه زبان
- ثبت‌نام و لاگین نمایشی با localStorage
- تاریخچه New.Cup / Apha Cup / Apha Super Cup
- اخبار و شایعات با برچسب «تأیید نشده»
- فرم ثبت‌نام مسابقات
- لینک Rubika: @dianfarroki
- معرفی Owners: RYVEN & KAIRO
- بخش New.Cup.Support
- ریسپانسیو برای موبایل و کامپیوتر
- آماده انتشار روی GitHub Pages

## انتشار روی GitHub Pages
1. یک Repository بساز.
2. `index.html` و `logo.jpg` را داخل Repository آپلود کن.
3. برو به Settings → Pages.
4. Source را روی Deploy from a branch بگذار.
5. Branch را روی `main` و Folder را `/root` انتخاب کن.
6. Save.

### نکته مهم درباره حساب‌ها
این نسخه برای دمو/سایت استاتیک است؛ حساب‌ها فقط در مرورگر کاربر با `localStorage` ذخیره می‌شوند و دیتابیس یا احراز هویت واقعی ندارند. برای حساب واقعی بین چند دستگاه، باید بک‌اند/دیتابیس اضافه شود.


## اتصال واقعی به Supabase
این نسخه به پروژه Supabase وصل شده است. قبل از انتشار نسخه جدید، فایل `SUPABASE_MIGRATION.sql` را در SQL Editor پروژه اجرا کن.
بعد از اجرای Migration:
- حساب‌ها با Supabase Auth واقعی هستند.
- ثبت‌نام تیم‌ها در `tournament_registrations` ذخیره می‌شود.
- کاربر وضعیت درخواست خودش را می‌بیند.
- Adminهای ثبت‌شده در `admin_users` پنل Admin را می‌بینند.
- Admin می‌تواند درخواست‌ها را تأیید/رد و برایشان یادداشت ثبت کند.
