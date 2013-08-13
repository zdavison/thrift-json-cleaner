namespace java com.mttnow.m2plane.ej.api

include "parent/m2core.thrift"
include "parent/m2p.thrift"

// 1000 series - flight disruptions
const i32 EJ_FLIGHT_DISRUPTION_NONE = 1000
const i32 EJ_FLIGHT_DISRUPTION_UNKNOWN = 1001
const i32 EJ_FLIGHT_DISRUPTION_LEVEL_1 = 1002
const i32 EJ_FLIGHT_DISRUPTION_LEVEL_2 = 1003
const i32 EJ_FLIGHT_DISRUPTION_LEVEL_3 = 1004

const string EJ_FARE_CLASS_STANDARD = "Y"
const string EJ_FARE_CLASS_FLEXI = "M"

struct TEJBookingOptionsForm {
  1: required list<i32> sportEquipment, /* number of items per each available sport eq. names and <min,max> comes with formDesc */
  2: required i32 baggage,              /* number of bags, global for booking. possible options + fee comes with formDesc */
  3: required i32 speedyBoarding,       /* 0 or 1. with bool we would have to create TFieldBool and duplicate TFieldNumber */
  4: i32 insurance,                     /* not in FDD, let's plan for it. also i32 instead of BOOL, because bool is just specific case of int (0 or 1) */
  5: i32 carbonOffset                   /* as above */  
}

struct TEJSeatPriceInfo {
  1: required m2core.TCurrency price,
  2: required string seatDescription
}

struct TEJBookingOptionsPO {
  1: required TEJBookingOptionsForm form,   
  2: m2core.TFormDescriptor formDesc,       /* it need to contain all labels / fees for all optional items in form */
  3: required m2p.TPricing pricing,         /* same as in bookingsummary call */
  4: map<string,m2core.TTextList> info,      /* any text displayed on this page or subpages, e.g. "30$ per item". map, so we categorize them easily per type of option */
  5: bool isFlexi,
  6: bool containsBossRoute,
  7: map<i32, list<TEJSeatPriceInfo>> seatPriceInfo      /*this has the basic prices for seats for each flight component*/
}

struct TEJRefundBookingPO {
  1: required m2p.TPricing pricing,
  2: m2core.TTextList info
}

struct TEJContentPO {
  1: m2core.TTextLine header,
  2: list<m2core.TTextLine> content
}

enum TBoardingDoor {
	FRONT,
	REAR,
	NONE
}

struct TEJBoardingPass {
  1: required m2p.TBoardingPass boardingPass,
  2: required bool isFlexi,
  3: required string boardingPassNumber,
  4: required string boardingQueue,
  5: required m2core.TTime gateClose,
  6: required m2core.TTime departureTime,
  7: required string spanishDiscountIndicator,
  8: string seatNumber,
  9: string seatBand,
  10: TBoardingDoor boardingDoor,
  11: m2p.TSeatPurchaseType seatPurchaseType,
  12: m2p.TPassenger accompanyingPassenger,
  13: bool holdLuggage
}

struct TEJBoardingPassPO {
  1: required TEJBoardingPass boardingPass,
  2: required m2p.TPassengerCheckInStatus returnFlightCheckinStatus
}

struct TEJBoardingPassRecallForm {
  1: required m2core.TPnr pnr,
  2: required m2p.TPassenger passenger,
  3: required m2p.TFlight flight,
  4: required bool guestCheckin
}

enum CardType {
	CREDIT,
	DEBIT
}

struct TEJAvailabilityForm {
  1: required m2p.TRoute route
  2: required m2core.TDate departureDate,
  3: m2core.TDate returnDate,
  4: i32 numAdults,
  5: i32 numChildren,
  6: list<i32> childrenAges,
  7: i32 numInfants,
  8: bool returnTrip,
  9: bool useConnectionFlights,
  10: m2p.TCarrier preferredCarrier,
  11: string cabinClass,
  12: bool specialAssistance,
  13: bool childAssistance,
  14: bool flexibleDates,
  15: list<string> currencies,
  16: CardType cardType
}

struct TEJSearchCriteriaPO {
  1: required TEJAvailabilityForm form,
  2: m2core.TFormDescriptor formDesc,
  3: m2core.TCmsTiles cms
}

service TEJWrappedFeesService {
  map<string,CardType> getOftEnabledWithDefaultCardMap(),
  map<string,bool> displayWrappedFeesMap()
}

struct TEJPaymentDetailsPO {
  1: m2p.TPaymentDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: m2p.TPricing pricing,
  4: m2p.TPricing nonPreferredCardPricing
}

struct TEJCheckInStatusDetails {
  1: m2p.TPassengerCheckInStatus passengerCheckInStatus,
  2: m2core.TTextLine checkInStatusMessage,
  3: i32 maxNumberOfBoardingPasses
}

struct TUrl {
  1: string urlContent
}

struct TEJAncillariesRequestParameters {
  1: string language,
  2: string currency,
  3: string destinationIata,
  4: string firstName,
  5: string lastName,
  6: string title,
  7: string email,
  8: string phone,
  9: string arrivalDate,
  10: string departureDate,
  11: string appClient,
  12: string referrerScreen
}

service TEJBookingService extends m2p.TBookingService
{
  TEJBookingOptionsPO getBookingOptionsPO() throws (1: m2core.TServerException se),
  void setBookingOptionsPO(1: TEJBookingOptionsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  void refreshPricingWithCreditCardFee(1: required TEJPaymentDetailsPO po) throws (1: m2core.TServerException se),
  void setCreditCardFee(1: required m2p.TPaymentDetailsForm form) throws (1: m2core.TServerException se),
  m2p.TAirComponent getAirComponent(1: required i32 index) throws (1: m2core.TServerException se),
  TEJSearchCriteriaPO getEJSearchCriteriaPO() throws (1:m2core.TServerException se),
  void setPaymentType(1: required CardType cardType) throws (1:m2core.TServerException se),
  void setEJSearchDetails(1: required TEJAvailabilityForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TEJPaymentDetailsPO getEJPaymentDetailsPO() throws (1: m2core.TServerException se),
  bool isSeatSelectionEnabled() throws (1: m2core.TServerException se),
  void clearAllSeats() throws (1: m2core.TServerException se),
  TUrl getEuropcarUrl(1: TEJAncillariesRequestParameters requestParameters),
  TUrl getBookingDotComUrl(1: TEJAncillariesRequestParameters requestParameters),
  TUrl getInsuranceUrl(1: TEJAncillariesRequestParameters requestParameters)
}

service TEJBookingChangeService
{
  m2p.TReservationDetailsPO getManageBookingDetailsPO(1: m2p.TRecallCriteriaForm form) throws(1:m2core.TServerException se, 2: m2core.TValidationException ve),
  
  void setModifyBookingCriteria(1: i32 componentIndex) throws (1: m2core.TServerException se),

  TEJSearchCriteriaPO getModifySearchCriteriaPO() throws (1:m2core.TServerException se),

  void setModifySearchDetails(1: required TEJAvailabilityForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),

  m2p.TAvailabilityDetailsPO getModifyAvailabilityDetailsPO(1: required m2p.TAvailabilityQuery query) throws (1:m2core.TServerException se),

  void modifySelectFlight(1: required m2p.TSelectFlightReq request) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  m2p.TAdvancedPassengerDetailsPO getAdvancedPassengerDetailsPO() throws (1: m2core.TServerException se),
  
  void setAdvancedPassengerDetails(1: m2p.TPassengerDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),

  TEJBookingOptionsPO getModifyBookingOptionsPO() throws (1: m2core.TServerException se),

  void setModifyBookingOptionsPO(1: TEJBookingOptionsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TEJPaymentDetailsPO getModifyPaymentDetailsPO() throws (1: m2core.TServerException se),

  m2core.TPaymentResult setModifyPaymentDetails(1: m2p.TPaymentDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),

  m2p.TReservationDetailsPO getModifyConfirmationDetailsPO() throws (1: m2core.TServerException se),
  
  TEJRefundBookingPO getRefundBookingPO() throws (1: m2core.TServerException se),
  
  TEJContentPO getRefundConfirmationPO() throws (1: m2core.TServerException se)
}

enum TCabinBagsPolicyVersion {
  	DEFAULT_V1,
  	SMALLER_V2
}

struct TEJCabinBagsPolicyPO {
    1: TCabinBagsPolicyVersion cabinBagsPolicy,
}

struct TEJPolicyRolloutServicePO  {
    1: bool newCabinBagsPolicyEnabled,
    2: bool checkin123Enabled
}

struct TEJPolicyDatesForm {
    1: m2core.TDate bookingDate,
    2: m2core.TDate flightDate
}

service TEJCabinBagsPolicyService {
    TEJCabinBagsPolicyPO isCabinBagsSmallerBagsPolicy(1: m2core.TDate bookingDate, 2:m2core.TDate flightDate),
    TEJPolicyRolloutServicePO getPolicies(1: TEJPolicyDatesForm formData)
}

service TEJContentService {
  TEJContentPO getEJContent(1: required string contentId) throws (1: m2core.TServerException se)
  string getMessage(1: required string contentId),
  map<string,string> getMessages(1: required list<string> contentId)
  m2core.TTextList getMessagesAsTTextList(1: required list<string> contentId)
}

service TEJECommerceService {
  m2core.TTextList getECommerceData() throws (1: m2core.TServerException se)
}

service TEJCheckinService extends m2p.TCheckinService {
  TEJContentPO getDangersPO() throws (1: m2core.TServerException se),
  TEJBoardingPassPO getBoardingPass() throws (1: m2core.TServerException se)
  TEJBoardingPassPO refreshBoardingPass(1: TEJBoardingPassRecallForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve)
  binary getPassbookObject(1: TEJBoardingPassRecallForm form) throws (1: m2core.TServerException se)
  TEJCheckInStatusDetails getCheckInStatusDetails(1: i32 componentIndex) throws (1: m2core.TServerException se)
}

struct TEJFlightTrackerResultStatus {
  1: i32 id,
  2: i32 aid,
  3: string summary,
  4: string info,
  5: string detail,
  6: bool blogAvailable
}

struct TEJFlightTrackerResult {
    1: m2p.TFlight flight,
    2: TEJFlightTrackerResultStatus flightTrackerResultStatus
    3: bool canCheckInOnline
}

struct TEJFlightTrackerBlogEntry {
   1: string blogText,
   2: string onBehalfOf,
   3: m2core.TDateTime created,
   4: string createdAgo
}

struct TEJFlightTrackerBlogPO {
   1: string flightNumber,
   2: m2core.TDate date,
   3: string eventHeader,
   4: list<TEJFlightTrackerBlogEntry> blogEntries
}

service TEJFlightTrackerService {
  list<TEJFlightTrackerResult> getFlightTrackerResultList(1: required m2p.TFlightInfoSearchForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TEJFlightTrackerBlogPO getFlightTrackerBlogPO (1:string pnr, 2:m2core.TDate date) throws (1: m2core.TServerException se)
}
