-- Displays the most recent transaction of every customer.

CREATE OR REPLACE FUNCTION p4() RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			select distinct Account
			from c
			order by Account;

		c_acc 		CHAR(5);

		c_name 		CHAR(20);
		t_amount 	INTEGER;
		v_name		CHAR(20);

	BEGIN
		open c1;
			raise notice 'Most Recent Transactions.';
			raise notice '';
		loop
			fetch c1 into c_acc;
			exit when not found;

			-- Get all transaction for current account Id.
			perform  * from t where t.Account = c_acc;

			if not found then
				raise notice 'Account Number: %', c_acc;
				raise notice 'no transaction';
				raise notice '';
			else
				select  Cname, Amount, Vname
				into	c_name, t_amount, v_name
                        	from    c,v,t
                        	where   t.Account = c_acc AND
                                	t.Vno = v.Vno AND
                                	t.T_Date =
                                	(
                                        	SELECT min(T_Date)
                                        	FROM t b
                                        	WHERE t.Account = b.Account
                               	 	);

				raise notice 'Account Number: %', c_acc;
				raise notice 'Name: %', c_name;
				raise notice 'Amount: %', t_amount;
				raise notice 'Vendor: %', v_name;
				raise notice '';
			end if;
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
