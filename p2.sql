-- Displays information about the customers who have had transaction with a given vendor.
-- For each transaction with vendor: display Customer_Account, Customer_Name, Province.
-- Accepts vendor name as a parameter.

CREATE OR REPLACE FUNCTION p2(vend_name CHAR) RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			SELECT 	c.Account, Cname, Province 
			FROM 	v,c,t
			WHERE 	v.Vname = vend_name AND 
				v.Vno = t.Vno AND
				t.Account = c.Account;	
		
		cust_acc CHAR(20);
		cust_name CHAR(20);
		cust_prov CHAR(3);
	BEGIN
		open c1;
			raise notice 'Vendor: %', vend_name;
			raise notice '';
		loop
			fetch c1 into cust_acc, cust_name, cust_prov;
			exit when not found;
			raise notice 'Customer Number: %', cust_acc;
			raise notice 'Name: %', cust_name;
			raise notice 'Province: %', cust_prov;
			raise notice '';
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
