# ================================ #
# HR Attrition Analysis Script     #
# Orion Tran                       #
# ================================ #

# ===================================== #
# PART 1: Context, Data Import & Cleaning
# ===================================== #

# This dataset contains 311 employees with demographic, job, and performance info.
# Goal: Identify what drives attrition, highlight hotspots, and confirm statistically.

library(readr)
library(dplyr)
library(janitor)
library(lubridate)
library(ggplot2)
library(tibble)

# Read + clean raw CSV
turnover_data <- read_csv("~/Project Datasets/HRDataset_v14.csv") %>%
  clean_names() %>%
  mutate(
    # Parse dates into R date format
    dateof_hire        = mdy(dateof_hire),
    dateof_termination = mdy(dateof_termination),
    last_performance_review_date = mdy(last_performance_review_date)
  )

# Snapshot date
snap <- max(turnover_data$dateof_termination,
            turnover_data$last_performance_review_date,
            turnover_data$dateof_hire,
            na.rm = TRUE)

# Feature engineering (continuous variables)
turnover_data <- turnover_data %>%
  mutate(
    attrition_flag = termd,
    end_date = if_else(!is.na(dateof_termination), dateof_termination, snap),
    years_at_company = as.numeric(difftime(end_date, dateof_hire, units = "days")) / 365.25,
    # Keep continuous variables instead of bands
    salary_cont = salary,
    engagement_cont = engagement_survey
  ) %>%
  select(
    -employee_name, -emp_id, -manager_id,
    -married_id, -marital_status_id, -gender_id, -emp_status_id,
    -dept_id, -perf_score_id, -position_id, -zip
  )

# ===================================== #
# PART 2: KPIs & Exploratory Data Analysis
# ===================================== #

# --- Overall Attrition Rate ---
overall_attrition_rate <- mean(turnover_data$attrition_flag, na.rm = TRUE)

overall_tbl <- turnover_data %>%
  mutate(attrition_status = if_else(attrition_flag == 1, "Attrited", "Still employed")) %>%
  count(attrition_status) %>%
  mutate(pct = n / sum(n))

ggplot(overall_tbl, aes(attrition_status, pct, fill = attrition_status)) +
  geom_col() +
  geom_text(aes(label = paste0(round(pct*100), "%")), vjust = -0.3) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_manual(values = c("Attrited" = "darkred", "Still employed" = "gray70")) +
  labs(title = "Overall Attrition", x = NULL, y = "Percent") +
  theme_minimal() +
  guides(fill = "none")

# --- Attrition by Tenure (Continuous) ---
tenure_attrition <- turnover_data %>%
  mutate(tenure_year = floor(years_at_company)) %>%
  group_by(tenure_year) %>%
  summarise(
    headcount = n(),
    n_attrited = sum(attrition_flag == 1, na.rm = TRUE),
    attrition_rate = n_attrited / headcount,
    .groups = "drop"
  )

ggplot(tenure_attrition, aes(x = tenure_year, y = attrition_rate, fill = attrition_rate)) +
  geom_col() +
  geom_text(aes(label = paste0(n_attrited, " / ", headcount)),
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(breaks = tenure_attrition$tenure_year) +
  scale_fill_gradient(low = "lightgray", high = "darkred") +
  labs(title = "Attrition Rate by Tenure (Years at Company)",
       x = "Years at Company", y = "Attrition Rate") +
  guides(fill = "none") +
  theme_minimal()


# --- Attrition by Department ---
dept_attrition <- turnover_data %>%
  group_by(department) %>%
  summarise(
    headcount = n(),
    n_attrited = sum(attrition_flag == 1, na.rm = TRUE),
    attrition_rate = n_attrited / headcount,
    .groups = "drop"
  )

ggplot(dept_attrition, aes(x = reorder(department, -attrition_rate), y = attrition_rate, fill = attrition_rate)) +
  geom_col() +
  geom_text(aes(label = paste0(n_attrited, " / ", headcount)),
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  scale_fill_gradient(low = "lightgray", high = "darkred") +
  labs(title = "Attrition Rate by Department",
       x = "Department", y = "Attrition Rate") +
  guides(fill = "none") +
  theme_minimal()


# --- Drill-down: Production Department ---

# Attrition by Tenure within Production
prod_tenure_attrition <- turnover_data %>%
  filter(department == "Production") %>%
  mutate(tenure_year = floor(years_at_company)) %>%
  group_by(tenure_year) %>%
  summarise(
    headcount = n(),
    n_attrited = sum(attrition_flag == 1, na.rm = TRUE),
    attrition_rate = n_attrited / headcount,
    .groups = "drop"
  )

ggplot(prod_tenure_attrition, aes(x = tenure_year, y = attrition_rate, fill = attrition_rate)) +
  geom_col() +
  geom_text(aes(label = paste0(n_attrited, " / ", headcount)),
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(breaks = prod_tenure_attrition$tenure_year) +
  scale_fill_gradient(low = "lightgray", high = "darkred") +
  labs(title = "Attrition Rate by Tenure within Production",
       x = "Years at Company", y = "Attrition Rate") +
  guides(fill = "none") +
  theme_minimal()


# Attrition by Satisfaction within Production
prod_satisfaction_attrition <- turnover_data %>%
  filter(department == "Production") %>%
  group_by(emp_satisfaction) %>%
  summarise(
    headcount = n(),
    n_attrited = sum(attrition_flag == 1, na.rm = TRUE),
    attrition_rate = n_attrited / headcount,
    .groups = "drop"
  )

ggplot(prod_satisfaction_attrition, aes(x = emp_satisfaction, y = attrition_rate, fill = attrition_rate)) +
  geom_col() +
  geom_text(aes(label = paste0(n_attrited, " / ", headcount)),
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  scale_x_continuous(breaks = prod_satisfaction_attrition$emp_satisfaction) +
  scale_fill_gradient(low = "lightgray", high = "darkred") +
  labs(title = "Attrition by Satisfaction within Production",
       x = "Satisfaction (1–5)", y = "Attrition Rate") +
  guides(fill = "none") +
  theme_minimal()


# Attrition by Engagement Bands within Production
prod_engagement_attrition <- turnover_data %>%
  filter(department == "Production") %>%
  mutate(engagement_band = ntile(engagement_survey, 4)) %>%
  group_by(engagement_band) %>%
  summarise(
    headcount = n(),
    n_attrited = sum(attrition_flag == 1, na.rm = TRUE),
    attrition_rate = n_attrited / headcount,
    .groups = "drop"
  ) %>%
  mutate(engagement_band = factor(engagement_band,
                                  labels = c("Q1 (Low)", "Q2", "Q3", "Q4 (High)")))

ggplot(prod_engagement_attrition, aes(x = engagement_band, y = attrition_rate, fill = attrition_rate)) +
  geom_col() +
  geom_text(aes(label = paste0(n_attrited, " / ", headcount)),
            vjust = -0.3, size = 3) +
  scale_y_continuous(labels = scales::percent, expand = expansion(mult = c(0, 0.1))) +
  scale_fill_gradient(low = "lightgray", high = "darkred") +
  labs(title = "Attrition by Engagement Band within Production",
       x = "Engagement Quartile", y = "Attrition Rate") +
  guides(fill = "none") +
  theme_minimal()

# ===================================== #
# PART 3: Logistic Regression
# ===================================== #

# Confirm which factors matter when controlling for others
model <- glm(
  attrition_flag ~ department + years_at_company + emp_satisfaction +
    engagement_cont + salary_cont,
  data = turnover_data,
  family = binomial()
)

# Odds ratios
or <- exp(coef(model))
ci <- confint.default(model)
ci <- exp(ci)
p  <- summary(model)$coefficients[, "Pr(>|z|)"]

or_table <- tibble(
  term = names(or),
  odds_ratio = round(as.numeric(or), 2),
  conf_low   = round(as.numeric(ci[, 1]), 2),
  conf_high  = round(as.numeric(ci[, 2]), 2),
  p_value    = round(as.numeric(p), 3)
) %>%
  arrange(p_value)

or_table


# ===================================== #
# PART 4: Focused Statistical Tests
# ===================================== #

# Chi-square: Department × Attrition (broad difference check)
tbl_dept <- table(turnover_data$department, turnover_data$attrition_flag)
chi_res <- chisq.test(tbl_dept)

# t-test: Tenure vs Attrition (confirm shorter tenure attrits more)
t_res <- t.test(years_at_company ~ attrition_flag, data = turnover_data)

# Chi-square: Production vs Others (confirm hotspot significance)
turnover_data <- turnover_data %>%
  mutate(prod_vs_other = if_else(department == "Production", "Production", "Other"))
tbl_prod <- table(turnover_data$prod_vs_other, turnover_data$attrition_flag)
prod_chi <- chisq.test(tbl_prod)

# Summary table of essential tests
test_summary <- tribble(
  ~Test, ~Variables, ~Statistic, ~p_value, ~Interpretation,
  
  "Chi-Square", "Department × Attrition", round(chi_res$statistic, 2), signif(chi_res$p.value, 3),
  ifelse(chi_res$p.value < 0.05, "Attrition differs by department", "No difference across departments"),
  
  "t-Test", "Tenure (years) × Attrition", round(t_res$statistic, 2), signif(t_res$p.value, 3),
  ifelse(t_res$p.value < 0.05, "Average tenure differs (shorter = higher attrition)", "No significant tenure difference"),
  
  "Chi-Square", "Production vs Others × Attrition", round(prod_chi$statistic, 2), signif(prod_chi$p.value, 3),
  ifelse(prod_chi$p.value < 0.05, "Attrition significantly higher in Production", "No significant Production difference")
)

test_summary

# ROI estimate (aggressive: all employees, 9 months salary)
avg_salary <- mean(turnover_data$salary, na.rm = TRUE)
aggressive_savings <- avg_salary * 0.75 * (nrow(turnover_data) * 0.05)

# Conservative version:
# - Use 6 months of salary (0.5 instead of 0.75)
# - Apply 5% reduction only to Production employees
prod_count <- nrow(filter(turnover_data, department == "Production"))
conservative_savings <- avg_salary * 0.5 * (prod_count * 0.05)

aggressive_savings
conservative_savings
