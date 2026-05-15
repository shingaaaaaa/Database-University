import csv, random, os
from datetime import date, datetime, timedelta

OUT = "."
random.seed(42)

# ─── Данные для генерации
LAST_NAMES = ["Иванов","Петров","Сидоров","Кузнецов","Смирнов","Попов","Лебедев",
              "Новиков","Морозов","Волков","Соколов","Михайлов","Зайцев","Козлов",
              "Орлов","Николаев","Фёдоров","Алексеев","Степанов","Тимофеев"]
FIRST_NAMES = ["Иван","Пётр","Алексей","Мария","Анна","Ольга","Дмитрий","Андрей",
               "Сергей","Елена","Наталья","Светлана","Виктор","Павел","Константин"]
MIDNAMES = ["Иванович","Петрович","Александрович","Владимирович","Сергеевич",
            "Алексеевна","Петровна","Викторовна","Дмитриевна","Андреевна"]
DOMAINS = ["mail.ru","yandex.ru","gmail.com","rambler.ru","inbox.ru"]

PROD_ADJ  = ["Профессиональный","Студийный","Концертный","Классический","Цифровой",
             "Акустический","Электрический","Компактный","Портативный","Премиум"]
PROD_NOUN = ["комплект","набор","модель","инструмент","система","серия"]
BRANDS    = list(range(1, 13))   # 12 брендов
CATS      = list(range(1, 11))   # 10 категорий
EMPLOYEES = list(range(1, 11))   # 10 сотрудников

# ─── Вспомогалки
def rand_date(start=date(2022,1,1), end=date(2024,12,31)):
    delta = (end - start).days
    return start + timedelta(days=random.randint(0, delta))

def rand_dt(start=datetime(2023,1,1), end=datetime(2024,12,31,23,59)):
    delta = int((end - start).total_seconds())
    return start + timedelta(seconds=random.randint(0, delta))

phones_used = set()
def unique_phone():
    while True:
        p = "+7" + str(random.randint(9000000000, 9999999999))
        if p not in phones_used:
            phones_used.add(p)
            return p

emails_used = set()
def unique_email(ln, fn):
    base = f"{ln.lower()}.{fn.lower()}"
    candidate = f"{base}@{random.choice(DOMAINS)}"
    if candidate not in emails_used:
        emails_used.add(candidate)
        return candidate
    for i in range(1, 1000):
        candidate = f"{base}{i}@{random.choice(DOMAINS)}"
        if candidate not in emails_used:
            emails_used.add(candidate)
            return candidate

# ============================================================
# 1. customers_bulk.csv (10 000 строк)
# ============================================================
N_CUST = 10000
with open(f"{OUT}/customers_bulk.csv","w",newline="",encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["last_name","first_name","middle_name","phone","email","registration_date"])
    for _ in range(N_CUST):
        ln = random.choice(LAST_NAMES)
        fn = random.choice(FIRST_NAMES)
        mn = random.choice(MIDNAMES)
        ph = unique_phone()
        em = unique_email(ln, fn)
        rd = rand_date()
        w.writerow([ln, fn, mn, ph, em, rd])
print(f"customers_bulk.csv: {N_CUST} строк")

# ============================================================
# 2. products_bulk.csv (10 000 строк)
# ============================================================
N_PROD = 10000
with open(f"{OUT}/products_bulk.csv","w",newline="",encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["name","description","retail_price","quantity_in_stock",
                "minimum_stock","category_id","brand_id"])
    for i in range(N_PROD):
        adj   = random.choice(PROD_ADJ)
        noun  = random.choice(PROD_NOUN)
        name  = f"{adj} {noun} #{i+1}"
        desc  = f"Артикул {random.randint(10000,99999)}. {adj} {noun} для профессионального использования."
        price = round(random.uniform(500, 250000), 2)
        stock = random.randint(0, 200)
        minst = random.randint(1, 20)
        cat   = random.choice(CATS)
        brand = random.choice(BRANDS)
        w.writerow([name, desc, price, stock, minst, cat, brand])
print(f"products_bulk.csv: {N_PROD} строк")

# ============================================================
# 3. sales_bulk.csv (15 000 строк)
# ============================================================
N_SALE = 15000
# customer_id от 1 до N_CUST (все клиенты существуют)
CUST_IDS_RANGE = list(range(1, N_CUST + 1))  # 1..10000
with open(f"{OUT}/sales_bulk.csv","w",newline="",encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["datetime","total_amount","customer_id","employee_id"])
    for _ in range(N_SALE):
        dt  = rand_dt()
        amt = round(random.uniform(300, 500000), 2)
        cid = random.choice(CUST_IDS_RANGE)
        eid = random.choice(EMPLOYEES)
        w.writerow([dt, amt, cid, eid])
print(f"sales_bulk.csv: {N_SALE} строк")

# ============================================================
# 4. sale_items_bulk.csv (30 000 строк)
# ============================================================
N_SI = 30000
# sale_id от 1 до N_SALE (все продажи существуют)
SALE_IDS_RANGE = list(range(1, N_SALE + 1))  # 1..15000
# product_id от 1 до N_PROD (все товары существуют)
PROD_IDS_RANGE = list(range(1, N_PROD + 1))  # 1..10000
with open(f"{OUT}/sale_items_bulk.csv","w",newline="",encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["sale_id","product_id","quantity","price_at_sale"])
    for _ in range(N_SI):
        sid   = random.choice(SALE_IDS_RANGE)
        pid   = random.choice(PROD_IDS_RANGE)
        qty   = random.randint(1, 10)
        price = round(random.uniform(300, 150000), 2)
        w.writerow([sid, pid, qty, price])
print(f"sale_items_bulk.csv: {N_SI} строк")

# ============================================================
# 5. reviews_bulk.csv (12 000 строк)
# ============================================================
N_REV = 12000
COMMENTS = [
    "Отличный товар, рекомендую!",
    "Хорошее качество за свои деньги.",
    "Не совсем то, что ожидал.",
    "Покупкой доволен, всё пришло быстро.",
    "Средне, есть и лучше варианты.",
    "Превзошло ожидания!",
    "Буду заказывать ещё.",
    "Качество на уровне, цена адекватная.",
]
with open(f"{OUT}/reviews_bulk.csv","w",newline="",encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["customer_id","product_id","rating","comment","datetime"])
    for _ in range(N_REV):
        cid  = random.choice(CUST_IDS_RANGE)
        pid  = random.choice(PROD_IDS_RANGE)
        rat  = random.randint(1, 5)
        com  = random.choice(COMMENTS)
        dt   = rand_dt()
        w.writerow([cid, pid, rat, com, dt])
print(f"reviews_bulk.csv: {N_REV} строк")

print("\nГотово! Файлы сохранены в текущей директории")
print("=" * 50)
print("Статистика созданных файлов:")
print(f"  customers_bulk.csv:   {N_CUST:>6} строк (клиенты)")
print(f"  products_bulk.csv:    {N_PROD:>6} строк (товары)")
print(f"  sales_bulk.csv:       {N_SALE:>6} строк (продажи)")
print(f"  sale_items_bulk.csv:  {N_SI:>6} строк (позиции продаж)")
print(f"  reviews_bulk.csv:     {N_REV:>6} строк (отзывы)")
print("=" * 50)