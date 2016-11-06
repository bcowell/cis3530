-- Displays information about all the transactions of a given customer.
-- For each transaction: display Vname, T_Date, Amount.
-- Accepts Cname as a parameter.

CREATE OR REPLACE FUNCTION p1(cust_name CHAR) RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			SELECT 	Vname, T_Date, Amount 
			FROM 	v,c,t
			WHERE	c.Cname = cust_name AND 
				c.Account = t.Account AND 
				t.Vno = v.Vno;	
		
		vend_name CHAR(20);
		tran_date DATE;
		tran_amount INTEGER;
	BEGIN
		open c1;
			raise notice 'Customer: %', cust_name;
			raise notice '';
		loop
			fetch c1 into vend_name, tran_date, tran_amount;
			exit when not found;
			raise notice 'Vendor Name: %', vend_name;
			raise notice 'Date: %', tran_date;
			raise notice 'Amount: %', tran_amount;
			raise notice '';
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
