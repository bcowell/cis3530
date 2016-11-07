-- Adds a new transaction.
-- Arguments: Tno, Vno, Account, Amount
-- Stores the new transaction into t where T_Date is set as current_date.
-- Then updates the balances of applicable customers and vendors.
-- Displays the new transaction, updated customer and vendor.

CREATE OR REPLACE FUNCTION p8(t_tno CHAR, t_vno CHAR, t_acc CHAR, t_amount INTEGER) RETURNS VOID AS $$
	DECLARE
		c1 CURSOR for SELECT * FROM t where Tno = t_tno;
		c2 CURSOR for SELECT * FROM c where Account = t_acc;
		c3 CURSOR for SELECT * FROM v where Vno = t_vno;

		v_no		CHAR(5);
		v_name		CHAR(20);
		v_city		CHAR(20);
		v_bal	 	DECIMAL(6,2);

		c_account	CHAR(5);
		c_name		CHAR(20);
		c_prov		CHAR(3);
		c_bal		DECIMAL(6,2);
		c_crlimit	INTEGER;

		t_no		CHAR(5);
		t_am		INTEGER;
		t_date		DATE;
	BEGIN
		raise notice 'Adding new transaction.';
		raise notice '';

		open c2;
		fetch c2 into c_account, c_name, c_prov, c_bal, c_crlimit;		
		if (c_bal < t_amount) then
			raise notice 'Customer has insufficient funds! Has: %, needs: %.', c_bal, t_amount;
		else
	
			INSERT INTO t VALUES
			(t_tno, t_vno, t_acc, current_date, t_amount);
			
				
			-- Subtract Amount the customers balance.
			UPDATE 	c
			SET 	Cbalance = Cbalance - t_amount
			WHERE	Account = t_acc; 
			
			-- Add Amount to the vendors balance.
			UPDATE v
			SET Vbalance = Vbalance + t_amount
			WHERE Vno = t_vno;

			open c1; 
			open c3;

                	fetch c1 into t_no, v_no, c_account, t_date, t_am;
                	fetch c3 into v_no, v_name, v_city, v_bal;

			raise notice 'Transaction:';
			raise notice 'Transaction No.: %', t_no;
			raise notice 'Vendor No.: %', v_no;
			raise notice 'Account: %', c_account;
			raise notice 'Date: %', t_date;
			raise notice 'Amount: %', t_am;
			raise notice '';


			raise notice 'Updated Customer:';
			raise notice 'Account: %', c_account;
			raise notice 'Name: %', c_name;
			raise notice 'Province: %', c_prov;
			raise notice 'Balance: %', c_bal;
			raise notice 'CrLimit: %', c_crlimit;
			raise notice '';

			raise notice 'Updated Vendor:';
			raise notice 'Vendor No.: %', v_no;
			raise notice 'Vendor: %', v_name;
			raise notice 'City: %', v_city;
			raise notice 'Balance: %', v_bal;
			close c1;
			close c3;
		end if;
		close c2;
	END;
$$ LANGUAGE plpgsql;
