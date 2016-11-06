-- Charges a service fee to each customer over their credit limit.
-- Service fee is 10% of the portion over the Crlimit.
-- Displays Cname and updated balance.

CREATE OR REPLACE FUNCTION p7() RETURNS VOID AS $$
	DECLARE
		c1 CURSOR FOR
			select distinct Account, Cname, Cbalance, Crlimit
			from c
			order by Account;

		c_acc 		CHAR(5);
		c_name 		CHAR(20);
		c_bal	 	DECIMAL(6,2);
		c_crlimit	INTEGER;
		new_bal 	DECIMAL(6,2);
		fee		DECIMAL(6,2);

	BEGIN
		open c1;
			raise notice 'Charging each customer over their credit limit a Service Fee.';
			raise notice '';
		loop
			fetch c1 into c_acc, c_name, c_bal, c_crlimit;
			exit when not found;
			
			if (c_bal > c_crlimit) then
				fee := (c_bal - c_crlimit) * 0.10;
				new_bal := c_bal - fee;
				
				-- Update the customers balance.
				UPDATE 	c 
				SET 	Cbalance = new_bal
				WHERE	Account = c_acc; 
			
				raise notice 'Customer Name: %', c_name;
				raise notice 'Fee Charged: %', fee;
				raise notice 'New Balance: %', new_bal;
				raise notice '';
			end if;
		end loop;
		close c1;
	END;
$$ LANGUAGE plpgsql;
