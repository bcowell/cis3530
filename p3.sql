-- Inserts a new customer record. Then displays all the customer records. 
-- Takes paramters: Customer_Account, Customer_Name, Province, Credit_Limit
-- Set inital balance to 0.00

CREATE OR REPLACE FUNCTION p3(c_acc CHAR, c_name CHAR, c_prov CHAR, c_limit INTEGER) RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			SELECT 	*
			FROM c;

		cust_acc 	CHAR(5);
		cust_name 	CHAR(20);
		cust_prov 	CHAR(3);
		cust_bal 	DECIMAL(6,2);
		cust_lim 	INTEGER;

	BEGIN
		INSERT INTO c VALUES
		(c_acc, c_name, c_prov, 0.00, c_limit);

		open c1;
			
		loop
			fetch c1 into cust_acc, cust_name, cust_prov, cust_bal, cust_lim;
			exit when not found;
			raise notice 'Customer Number: %', cust_acc;
			raise notice 'Name: %', cust_name;
			raise notice 'Province: %', cust_prov;
			raise notice 'Balance: %', cust_bal;
			raise notice 'Credit Limit: %', cust_lim;
			raise notice '';
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
