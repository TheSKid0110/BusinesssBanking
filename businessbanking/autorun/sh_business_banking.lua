BUSINESS_BANKING = BUSINESS_BANKING or {}

-- The interest timer is how often the interest is calculated and added to the player's balance.
BUSINESS_BANKING.InterestTimer = 60
-- The interest rate is the percentage of the player's balance that is added to their balance every time the interest timer is triggered.
BUSINESS_BANKING.InterestRate = 0.05
-- The bank cut is the percentage of cut the bank takes from the player when they make a purchase.
BUSINESS_BANKING.BankCut = 0.08
