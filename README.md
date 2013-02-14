# CheckMate Shopper

Sample iOS Code!

## TODO

* Refactor CMShopperHTTPClient.  Building the request and sending it can be abstracted between the three methods.
* Refactor new item and edit item views into a single view. The view will contain the name text field, category text field, and save button. This would also simplify validations.
* Display an error to user on network failures.
* Handle deletes made from other clients. This can be done by deleting all of the existing items before loading them from the server.
* Fix animation when adding/editing.
* Create protocol for dismissing new/edit item view controllers. They shouldn't be dismissing themselves, the parent should do that.
