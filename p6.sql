-- Charges each vendor a 4% service fee.
-- Displays Vname, Fee Charged, updated Vbalance.

CREATE OR REPLACE FUNCTION p6() RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			select distinct Vno, Vname, Vbalance
			from v
			order by Vno;

		v_no 		CHAR(5);
		v_name 		CHAR(20);
		v_bal	 	DECIMAL(6,2);
		new_bal 	DECIMAL(6,2);

	BEGIN
		open c1;
			raise notice 'Charging each vendor 4%% Service Fee.';
			raise notice '';
		loop
			fetch c1 into v_no, v_name, v_bal;
			exit when not found;

			new_bal := v_bal * 0.04;

			-- Update the vendors balance.
			UPDATE 	v 
			SET 	Vbalance = Vbalance - new_bal
			WHERE	Vno = v_no; 
			
			raise notice 'Vendor Name: %', v_name;
			raise notice 'Fee Charged: %', new_bal;
			raise notice 'New Balance: %', v_bal - new_bal;
			raise notice '';
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
