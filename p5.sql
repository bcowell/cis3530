-- Calculates each vendors current balance.
-- Does so by adding each transaction amount for each vendor in the transaction table to the total balance.
-- Displays Vno, Vname, updated Vbalance.

CREATE OR REPLACE FUNCTION p5() RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			select distinct Vno, Vname, Vbalance
			from v
			order by Vno;

		v_no 		CHAR(5);
		v_name 		CHAR(20);
		v_bal	 	DECIMAL(6,2);
		new_bal 	INTEGER;

	BEGIN
		open c1;
			raise notice 'Updating Vendor balances from list of transactions.';
			raise notice '';
		loop
			fetch c1 into v_no, v_name, v_bal;
			exit when not found;

			-- Get all transactions for current vendor.
			SELECT 	COALESCE(SUM(Amount), 0)
			INTO	new_bal
			FROM 	t 
			WHERE 	t.Vno = v_no;

			-- Update the vendors balance.
			UPDATE 	v 
			SET 	Vbalance = Vbalance + new_bal
			WHERE	Vno = v_no; 
			
			raise notice 'Vendor Number: %', v_no;
			raise notice 'Vendor Name: %', v_name;
			raise notice 'New Balance: %', new_bal + v_bal;
			raise notice '';
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
