## most_sold_items most_sold_item_for_merchant(merchant_id) method

For the most_sold_items most_sold_item_for_merchant(merchant_id) we first called in a previous method called method_ids that returns an array of all merchant id's. This method does this by iterating through the merchant repository and pulling out all merchant id's.

The merchant id's return value is used in the second helper method (merchant_invoice_hash). This method  creates a hash with the keys as merchant id's and the values as all the invoices associated with each merchant. We do this my iterating through the merchant id's array and using each element as a key in the new hash and setting it's values to all invoices with a matching merchant_id number. We iterate through the invoice repository using the find all enumerable to get this done.

We then create a hash with the default value as zero, to be used later. Next up, we have to find and flatten the invoice item arrays for the specific merchant that is called in as an argument.  We have to do this because the original values are array's of array's.  

Now, we iterate through the flattened array of invoice items for the specific merchant called in as an argument in the method (now called items). During this iteration, we set the key as the invoice item invoice id and total up the quantity for each invoice id. We can do this because we set the default value as 0.

We now have a hash that invoice_ids and the number of items for each one. This allows us to sort that hash(what we do next). We use the select enumerable because it will return multiple instances if more than one evaluates to true in the block.

We then iterate through the keys of the hash to create and array of item id's and then convert that to however many items class objects are associated with the item ids in the array.

## best_item_for_merchant(merchant_id)

We start off with the same two helper methods as in the previous method, so I won't explain those here. We also create a flattened array of invoice items associated with the merchant id argument (same as the last method).

We again create a new hash with the default value as zero. We then iterate through each item to calculate it's value (unit_price * quantity) and associate that with the item_id number in our hash.

This total value portion of the method is the most important part. Without this, everything we do going forward doesn't matter. By associating the total value with an item id, we make it easy to find the highest value and still return the item instance later (using the item id).

We then use the select method to find items worth the most. If there is a tie, it would return multiple values in a hash. So, when we do the final step and convert the most valuable item id to an instance of that item, we return the first value by calling on the [0] position of the top_item.keys array.

Once we have the final item id, we call on the item_repo.find_by_id method to turn it into an item instance.
