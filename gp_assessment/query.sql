-- ** • Calculate the total sales amount and the total number of transactions for each month. **

-- Выбираем усеченную дату покупки до уровня месяца, количество транзакций и сумму продаж
SELECT
    -- Усекаем дату покупки до начала каждого месяца
    DATE_TRUNC('month', purchase_date) AS each_month,
    -- Считаем количество идентификаторов транзакций за каждый месяц
    COUNT(transaction_id) AS total_transactions,
    -- Суммируем общую сумму продаж за каждый месяц
    SUM(total_amount) AS sales_amount
FROM
    sales_transactions
GROUP BY
    DATE_TRUNC('month', purchase_date)
ORDER BY
    DATE_TRUNC('month', purchase_date);




--##############################################################################################################




--** Calculate the 3-month moving average of sales amount for each month. The moving average should be calculated based on the sales data from the previous 3 months (including the current month). **
-- Определяем временную таблицу monthly_sales для вычисления ежемесячных продаж
WITH monthly_sales AS (
    SELECT
        -- Усечение даты покупки до начала месяца
        DATE_TRUNC('month', purchase_date) AS month,
        -- Суммирование общей суммы продаж за каждый месяц
        SUM(total_amount) AS total_sales_amount
    FROM
        sales_transactions
    GROUP BY
        DATE_TRUNC('month', purchase_date)
)
-- Основной запрос
SELECT
    month,
    total_sales_amount,
    -- Вычисление скользящего среднего для общей суммы продаж за текущий и два предыдущих месяца
    AVG(total_sales_amount) OVER (
        -- Упорядочение по месяцу
        ORDER BY month
        -- Скользящее окно: два предыдущих месяца и текущий месяц
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_sales_amount
FROM
    monthly_sales
ORDER BY
    month;
;

