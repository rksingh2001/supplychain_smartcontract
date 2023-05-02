// SPDX-License-Identifier: MIT     

pragma solidity ^0.8.0 ;
import "../Ownership/Ownable.sol" ;
import "../Access/Manufacturer.sol";
import "../Access/Distributor.sol";
import "../Access/Wholesaler.sol";
import "../Access/Retailer.sol";
import "../Access/Consumer.sol";

  contract Supplychain is 
    Manufacturer , 
    Distributor,
    Wholesaler,
    Retailer, 
    Consumer {
    address owner ;
    uint256 MedicineCode ;
    uint256 StockUnit ; 
    // Somethign somrne
    mapping( uint256 => Medicine ) medicines ;
    mapping( uint256 => Txblocks) medicinesHistory;
    enum state{
        ProducedByManufacturer, // 0
        ForSaleByManufacturer, // 1
        PurchasedByDistributor, // 2
        ShippedByManufacturer, // 3
        ReceivedByDistributor, // 4
        ForSaleByDistributor, // 5
        PurchasedByWholesaler, // 6
        ShippedByDistributor, // 7
        ReceivedByWholesaler, // 8
        ForSaleByWholesaler, // 9
        PurchasedByRetailer, // 10
        ReceivedByRetailer, // 11
        ForSaleByRetailer, // 12
        PurchasedByConsumer // 13
                
        

    }
        state constant defaultState = state.ProducedByManufacturer;

    struct Medicine {
    uint256 stockUnit; // Stock Unit 
    uint256 MedicineCode; // Product Code generated by the Manufacturer, goes on the package, can be verified by the Consumer
    address ownerID; // Wallet address of the current owner as the product moves through 8 stages
    address ManufacturerID; // Address of the Manufacturer 
    // string ManufacturerName; 
    string ManufacturerInfo; 
    uint256 MedicineID; // Product id: a combination of productCode + stockUnit
    uint256 ManufacturingDate; // Product date created
    uint256 MedicinePrice; // Product Price
    state MedicineState; // Product State as represented in the enum above
    address DistributorID; // Address of the Distributor
    string  DistributorInfo;
    address WholesalerID; // Address of the wholesaler 
    string WholesalerInfo;
    address RetailerID; // Address of the Retailer
    string RetailerInfo;
    address ConsumerID; // Address of the Consumer
    uint256 ProductQuantity; // product quantity

}
      struct Txblocks { 
        uint256 FTD; // block of ManufacturerToDistributor 
        uint256 DTW; // block of DistributorToWholesaler
        uint256 WTR ;// block of WholesalerTo Retailer 
        uint256 RTC; // block of RetailerToConsumer
       
      }
      event  ProducedByManufacturer(uint256 MedicineCode ); // 0
      event  ForSaleByManufacturer (uint256 MedicineCode );// 1
      event  PurchasedByDistributor (uint256 MedicineCode ); // 2
      event  ShippedByManufacturer (uint256 MedicineCode ); // 3
      event  ReceivedByDistributor (uint256 MedicineCode ); // 4
      event  ForSaleByDistributor(uint256 MedicineCode ); // 5
      event  PurchasedByWholesaler (uint256 MedicineCode ); // 6
      event  ShippedByDistributor (uint256 MedicineCode ); // 7
      event  ReceivedByWholesaler (uint256 MedicineCode ); // 8
      event  ForSaleByWholesaler (uint256 MedicineCode ); // 9
      event  PurchasedByRetailer (uint256 MedicineCode ); // 10
      event  ReceivedByRetailer (uint256 MedicineCode ); // 11
      event  ForSaleByRetailer (uint256 MedicineCode );// 12
      event  PurchasedByConsumer  (uint256 MedicineCode );// 13



    // // Define a modifer that checks to see if _msgSender() == owner of the contract
    // modifier only_Owner() {
    //     require(_msgSender() == owner);
    //     _;
    // }

    //           modifier verifyCaller(address _address) { 
    //             require(_msgSender() == _address); 
    //             _; 
    //           }
    //           modifier checkValue(uint256 _MedicineCode, address payable addressToFund) {        
    //             uint256 _price = medicines[_MedicineCode].MedicinePrice;        
    //             uint256 amountToReturn = msg.value - _price;
    //             addressToFund.transfer(amountToReturn);        
    //             _;    
    //           }
    // Define a modifer that checks to see if _msgSender() == owner of the contract
    modifier only_Owner() {
        require(_msgSender() == owner);
        _;
    }

    // Define a modifer that verifies the Caller
    modifier verifyCaller(address _address) {
        require(_msgSender() == _address);
        _;
    }

    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price);
        _;
    }

    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint256 _productCode, address payable addressToFund) {
        uint256 _price = medicines[_productCode].MedicinePrice;
        uint256 amountToReturn = msg.value - _price;
        addressToFund.transfer(amountToReturn);
        _;
    }


// item state modifier 
        modifier _ProducedByManufacturer (uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ProducedByManufacturer) ;
          _;
        }
         
        
        modifier _ForSaleByManufacturer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ForSaleByManufacturer) ;
          _;
        } 
        modifier _PurchasedByDistributor(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.PurchasedByDistributor) ;
          _;
        } // 2
        modifier _ShippedByManufacturer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ShippedByDistributor) ;
          _;
        }  // 3
        modifier _ReceivedByDistributor(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ReceivedByDistributor) ;
          _;
        }  // 4
        modifier _ForSaleByDistributor(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ForSaleByDistributor) ;
          _;
        }  // 5
        modifier _PurchasedByWholesaler (uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.PurchasedByWholesaler) ;
          _;
        }  // 6
        modifier _ShippedByDistributor(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ShippedByDistributor) ;
          _;
        }  // 7
        modifier _ReceivedByWholesaler(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ReceivedByWholesaler) ;
          _;
        }  // 8
         modifier _ForSaleByWholesaler(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ForSaleByWholesaler) ;
          _;
        }  // 9
        modifier _PurchasedByRetailer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.PurchasedByRetailer) ;
          _;
        }  // 10
        modifier _ReceivedByRetailer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ReceivedByRetailer) ;
          _;
        }  // 11
        modifier _ForSaleByRetailer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.ForSaleByRetailer) ;
          _;
        }  // 12
        modifier _PurchasedByConsumer(uint256 _MedicineCode){
          require(medicines[_MedicineCode].MedicineState == state.PurchasedByConsumer) ;
          _;
        }  // 13

        constructor() public payable {        
        owner = _msgSender();        
        StockUnit = 1;        
        MedicineCode = 1;    
}

            function MedicineProducedByManufacturer (
            uint256 _MedicineCode ,
            string memory  _ManufacturerName ,
            string  memory  _ManufacturerInfo ,
            uint256  _MedicinePrice )
            public onlyManufacturer{
               address DistributorID; // Empty distributorID address
              //  string   storage DistributorInfo;
               address wholesalerID; // empty wholesaler Address
              //  string storage WholesalerInfo;
               address RetailerID; // Empty retailerID address
                // string storage RetailerInfo ;
                address consumerID; // Empty consumerID address
                Medicine memory newProduce; // Create a new struct Item in memory
                newProduce.stockUnit = StockUnit; // Stock Keeping Unit (stockUnit)
                newProduce.MedicineCode = _MedicineCode; // Product Codegenerated by the Farmer, goes on the package, can be verified by the Consumer
                newProduce.ownerID = _msgSender(); // Metamask-Ethereum address of the current owner as the product moves through 8 stages
                newProduce.ManufacturerID = _msgSender(); // Metamask-Ethereum address of the Farmer
                newProduce.ManufacturerName = _ManufacturerName; // Farmer Name
                newProduce.ManufacturerInfo = _ManufacturerInfo;
                
                newProduce.MedicinePrice = _MedicinePrice; // Product Price
                newProduce.ManufacturingDate = block.timestamp;
                
                newProduce.MedicineState = defaultState; // Product State as represented in the enum above
                newProduce.DistributorID = DistributorID; // Metamask-Ethereum address of the Distributor
                newProduce.WholesalerID = wholesalerID ;
                newProduce.RetailerID = RetailerID; // Metamask-Ethereum address of the Retailer
                newProduce.ConsumerID = consumerID ; // Metamask-Ethereum address of the Consumer // ADDED payable
                medicines[_MedicineCode] = newProduce; // Add newProduce to items struct by productCode
                uint256 placeholder; // Block number place holder
                Txblocks memory Txblock; // create new txBlock struct
                Txblock.FTD = placeholder; // assign placeholder values
                Txblock.DTW = placeholder;
                Txblock.WTR = placeholder;
                Txblock.RTC = placeholder;
                medicinesHistory[_MedicineCode] = Txblock; // add txBlock to itemsHistory mapping by productCode

                // Increment stockUnit
                StockUnit = StockUnit + 1;

                // Emit the appropriate event
                emit ProducedByManufacturer(_MedicineCode);
            
                    }

          }  
            

                
