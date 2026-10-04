# New.Cup 2 — Supabase Edition

## راه‌اندازی
1. فایل `SUPABASE_MIGRATION.sql` را در Supabase → SQL Editor → New query قرار بده و Run کن.
2. `index.html` و `logo.jpg` را روی GitHub Pages یا هاست استاتیک قبلی جایگزین کن.
3. سایت به پروژه Supabase زیر وصل است:
   `https://slxbvkjnwccoiuspusut.supabase.co`

## قابلیت‌ها
- ساخت حساب و ورود واقعی با Supabase Auth
- ثبت‌نام تیم‌های 2v2 در دیتابیس
- وضعیت ثبت‌نام برای کاربر
- پنل Admin با آمار، تأیید، رد و یادداشت
- مدیریت کامل اخبار: افزودن، ویرایش، حذف و انتخاب خبر اصلی
- نمایش اخبار از دیتابیس در صفحه عمومی

## درباره ساخت حساب
اگر Email confirmation در Supabase فعال باشد، بعد از ساخت حساب باید ایمیل تأیید شود و سپس وارد حساب شد. اگر می‌خواهی بدون تأیید ایمیل وارد شوند، این گزینه را فقط از تنظیمات Authentication پروژه خودت تغییر بده.

## امنیت
- کلید داخل `index.html` فقط Publishable key است.
- هرگز `service_role` یا Secret key را داخل سایت قرار نده.
- دسترسی Admin با جدول `admin_users` و RLS کنترل می‌شود.
- اجرای `SUPABASE_MIGRATION.sql` برای جدول اخبار و Policyهای آن ضروری است.
