
namespace java com.mttnow.m2plane.api

include "m2core.thrift"

const string CACHE_SEARCHFORM = "searchform";
const string CACHE_AIRPORTS = "airports";

/*Flight disruption constants. Can be stored in statusCode in TFlightStatus and
mapped to flight disruptions as necessary per project*/
const i32 FLIGHT_DISRUPTION_NONE = 1000
const i32 FLIGHT_DISRUPTION_UNKNOWN = 1001
const i32 FLIGHT_DISRUPTION_LEVEL_1 = 1002
const i32 FLIGHT_DISRUPTION_LEVEL_2 = 1003
const i32 FLIGHT_DISRUPTION_LEVEL_3 = 1004
const i32 FLIGHT_DISRUPTION_LEVEL_4 = 1005
const i32 FLIGHT_DISRUPTION_LEVEL_5 = 1006
const i32 FLIGHT_DISRUPTION_LEVEL_6 = 1007
const i32 FLIGHT_DISRUPTION_LEVEL_7 = 1008
const i32 FLIGHT_DISRUPTION_LEVEL_8 = 1009
const i32 FLIGHT_DISRUPTION_LEVEL_9 = 1010
const i32 FLIGHT_DISRUPTION_LEVEL_10 = 1011

enum TAirportCheckInSupportType {
  DEFAULT = 0,
  AIRPORT_ONLY = 1,
  WEBSITE_ONLY = 2
}

enum TReservationType {
  REGULAR = 0,
  STAND_BY = 1 //this is for staff bookings
}

struct TAirport {
  1: required string iata,
  2: string name,
  3: m2core.TCity city,
  4: m2core.TCountry country,
  5: i32 lat,
  6: i32 lng,
  7: string timezone,
  8: TAirportCheckInSupportType airportCheckInSupportType
}
struct TAirportInfo {
  1: required TAirport airport,
  2: list<m2core.TWeather> weather,
  3: list<string> images,
  4: string content
}
struct TRoute {
  1: TAirport originAirport,
  2: TAirport destinationAirport
}
struct TCarrier {
  1: required string code,
  2: string name
}

struct TCabinClass{
 1: string cabinClass,
 2: string code
}

enum TCheckInStatus {
  NOT_AVAILABLE = 0,
  PENDING = 1,
  OPEN = 2,
  CLOSED = 3
}
struct TFlightStatus {
  1: string status,
  2: m2core.TDateTime scheduledDepartureTime,
  3: m2core.TDateTime scheduledArrivalTime,
  4: m2core.TDateTime actualDepartureTime,
  5: m2core.TDateTime actualArrivalTime,
  6: m2core.TDateTime estimatedDepartureTime,
  7: m2core.TDateTime estimatedArrivalTime,
  8: m2core.TDateTime lastUpdated,
  9: i32 statusCode
}

struct TTerminal{
  1: string terminalName,
  2: bool international
}

struct TLeg{
  1: TRoute route,
  2: m2core.TDateTime departureDate,
  3: m2core.TDateTime arrivalDate,
  4: string number,
  5: TCarrier carrier,
  6: string departureTerminal, //depricated
  7: string arrivalTerminal, //depricated
  8: TCheckInStatus checkInStatus,
  9: TFlightStatus flightStatus,
  10: bool refundPending,
  11: bool govtApproval,
  12: m2core.TPeriod stopOverPeriod,
  13: m2core.TTextList info,
  14: TTerminal departureTerminalInfo,
  15: TTerminal arrivalTerminalInfo,
  16: bool international
}
struct TFlight {
  1: TRoute route,
  2: m2core.TDateTime departureDate,
  3: m2core.TDateTime arrivalDate,
  4: string number,
  5: TCarrier carrier,
  6: TCheckInStatus checkInStatus,
  7: TFlightStatus flightStatus,
  8: bool refundPending,
  9: string departureTerminal,
  10: string arrivalTerminal,
  11: bool govtApproval,
  12: list<TLeg>legs,
  13: m2core.TTextList info,
  14: bool international
}
struct TAirComponent {
  1: list<TFlight> flights,
  2: m2core.TDateTime departureDate,
  3: m2core.TDateTime arrivalDate,
  4: i32 numberOfStops,
  5: m2core.TPeriod transitTime,
  6: map<string,i32> order,
  7: m2core.TTextList info,
  8: bool international
}
struct TFlightInfoGroup {
  1: required list<TAirComponent> components,
  2: m2core.TDate departureDate,
  3: TRoute route,
  4: m2core.TDateTime lastUpdated
}
struct TFlightSchedule {
  1: TAirComponent component,
  2: m2core.TDate startDate,
  3: m2core.TDate endDate,
  4: i32 daysOfWeek,
  5: m2core.TDateTime lastUpdated
}
enum TPassengerType {
  ADULT = 0,
  CHILD = 1,
  INFANT= 2
}

struct TPassengerDetails{
  1: string documentType,
  2: string documentNumber,
  3: string gender,
  4: m2core.TCountry nationality,
  5: m2core.TCountry documentIssuedBy,
  6: m2core.TDate documentIssueDate,
  7: m2core.TDate documentExpiryDate,
  8: string redressNumber,
  9: i32 accompanyingPassengerIdx,
  10: m2core.TCountry countryOfBirth,
  11: m2core.TCountry countryOfResidence
}

struct TPassenger {
  1: required TPassengerType paxType,
  2: string title,
  3: string firstName,
  4: string lastName,
  5: m2core.TDate dateOfBirth,
  6: string freqFlyerNumber,
  7: bool advancedDetailRequired,
  8: TPassengerDetails passengerDetails,
  9: string middleName
}

enum TSeatType {
  REGULAR = 0,
  EMERGENCY = 1,
  AISLE = 2,
  EXTRA_LEG_ROOM =3, 
  INFANT_SUITABLE = 4,
  NONE = 5
  AISLE_SPACE = 6
}
enum TSeatPurchaseType {
  ALLOCATED = 0,
  PURCHASED = 1
}
enum TSeatGroup {
  NONE = 0,
  EXTRA_LEG_ROOM = 1,
  UP_FRONT = 2,
  BUSINESS = 3,
  STANDARD = 4,
  SAVER = 5
}
enum TSeatRestriction {
  EMERGENCY = 0,
  INFANT = 1,
  CHILD = 2
}
struct TSeat {
  1: string number,
  2: TSeatType seatType, /* physical characteristic i.e. standard, window, aisle, aisle_space, none */
  3: m2core.TCurrency fee,
  4: bool available,
  5: TSeatGroup seatGroup, /* fee grouping */
  6: string rowLetter,
  7: list<TSeatRestriction> seatRestrictions /* the restriction category of this seat e.g. emergency*/
  8: string seatTag /* business characteristic i.e. pre-selected, purchased, none */
}
enum TPassengerCheckInStatus {
  NOT_AVAILABLE = 0,
  AVAILABLE = 1,
  CHECKEDIN = 2,
  CLOSED = 3,
  NO_MOBILE_CHECKIN = 4,
  NOT_OPEN = 5,
  CANCELLED = 6,
  APIS_REQUIRED = 7
}
struct TPassengerSelection {
  1: required i32 paxIdx,
  2: required i32 compIdx,
  3: required i32 flightIdx
}

enum TAncillaryType {
  BAGGAGE = 0,
  MEAL = 1,
  ENTERTAINMENT = 2,
  SPORTS_EQUIPMENT = 3,
  PRIORITY_BOARDING = 4,
  UNDEF = 5
}

struct TAncillaryInfo {
  1: string code,
  2: string name,
  3: TAncillaryType type
}
struct TPassengerSelectionEntry {
  1: TPassengerSelection selection,
  2: TPassengerCheckInStatus status,
  3: TSeat seat,
  4: list<m2core.TKeyValue> addons,
  5: list<TAncillaryInfo> ancillaries
}
struct TBoardingPass {
  1: required binary barcode,
  2: required TPassenger passenger,
  3: required TFlight flight,
  4: required m2core.TPnr pnr,
  5: required string sequenceNumber
}
struct TFareClass {
  1: i32 fareType,
  2: string fareDesc,
  3: string basisCode,
  4: m2core.TCurrency amount, // deprecated - use amounts
  5: bool mixedFare,
  6: m2core.TTextList fullDescription,
  7: bool soldOut
  8: map<TPassengerType, m2core.TCurrency> amounts,
  9: bool fareUnavailable
}

struct TSelectFlightReq {
  1: required i32 seq,
  2: required i32 compId,
  3: required i32 fareId,
  4: required m2core.TDate date
}
struct TAvailabilityForm {
  1: required TRoute route
  2: required m2core.TDate departureDate,
  3: m2core.TDate returnDate,
  4: i32 numAdults,
  5: i32 numChildren,
  6: list<i32> childrenAges,
  7: i32 numInfants,
  8: bool returnTrip,
  9: bool useConnectionFlights,
  10: TCarrier preferredCarrier,
  11: string cabinClass, 
  12: bool specialAssistance,
  13: bool childAssistance,
  14: bool flexibleDates,
  15: list<string> currencies
}
struct TSearchCriteriaPO {
  1: required TAvailabilityForm form,
  2: m2core.TFormDescriptor formDesc,
  3: m2core.TCmsTiles cms
}

struct TAirComponentPricingTable {
  1: TAirComponent component,
  2: m2core.TPricingTable table,
}
struct TPricing {
  1: required list<TAirComponentPricingTable> components,
  2: m2core.TPricingTable total,//Can use 1 pricing table or the list of tables. Stick with one or the other
  3: list<m2core.TPricingTable> tables
}
struct TBookingSummaryPO {
  1: required TPricing pricing
}
struct TReservation {
  1: list<TAirComponent> components,
  2: list<TPassenger> passengers,
  3: m2core.TPnr pnr,
  4: m2core.TPaymentStatus paymentStatus,
  5: string paymentStatusDetails,
  6: m2core.TContact contact,
  7: m2core.TDateTime created,
  8: bool isDisrupted,
  9: bool isPaymentComplete,
  10: bool checkInAvailable
}
struct TCompletedReservation {
  1: required TReservation reservation,
  2: TPricing pricing,
  3: m2core.TDateTime lastUpdated,
  4: list<TPassengerSelectionEntry> passengerSelection,
  5: bool readOnly,
  6: m2core.TTextList additionalInfo,
  7: list<m2core.TImage> images,
  8: TReservationType reservationType = TReservationType.REGULAR
}

struct TRecallCriteria {
  1: TRoute route,
  2: m2core.TDate date,
  3: string passengerName,
  4: string email
}
struct TAirportGroup {
  1: required m2core.TCountry country,
  2: list<TAirport> airports
}
struct TAvailabilityEntry {
  1: required TAirComponent component,
  2: required list<TFareClass> fareClasses,
  3: m2core.TTextList additionalInfo
}
struct TAvailabilityEntryList {
  1: m2core.TDate date,
  2: bool prevDayAllowed, //deprecated - use prevDate
  3: bool nextDayAllowed, //deprecated - use nextDate
  4: TFareClass lowerFareClass,
  5: list<TAvailabilityEntry> entries,
  6: m2core.TDate prevDate,
  7: m2core.TDate nextDate  
}
struct TAvailabilityDetailsPO {
  1: TRoute route,
  2: list<TAvailabilityEntryList> dayAvailability,
  3: list<TAvailabilityEntry> selected,
  4: i32 cacheSize,
  5: m2core.TCmsTiles cms
}
struct TPassengerDetailsForm {
  1: list<TPassenger> passengers
}
struct TPassengerDetailsPO {
  1: required TPassengerDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: TPricing pricing
}
struct TAdvancedPassengerDetailsPO{
  1: required TPassengerDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
}
struct TPassengerBaggageEntry {
  1: required TPassenger passenger,
  2: required list<string> baggage
}
struct TBaggageDetailsForm {
  1: required list<TPassengerBaggageEntry> passengers
}
struct TBaggageDetailsPO {
  1: required TBaggageDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: TPricing pricing
}
struct TPassengerAncillariesEntry {
  1: required TPassenger passenger,
  2: required list<map<string,string>> ancillaries
}
struct TAncillariesDetailsForm {
  1: required list<TPassengerAncillariesEntry> passengers    
}
struct TAncillariesDetailsPO {
  1: required TAncillariesDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: TPricing pricing,
  4: m2core.TTextList textList
}
struct TContactDetailsForm {
  1: required m2core.TContact contact
}
struct TContactDetailsPO {
  1: required TContactDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: TPricing pricing
}
struct TPaymentDetailsForm {
  1: required m2core.TCreditCard creditCard,
  2: bool storeCreditCard,
  3: m2core.TEncryptedCreditCard storedCreditCard,
  4: bool acceptedPaymentConditions
}
struct TPaymentDetailsPO {
  1: required TPaymentDetailsForm form,
  2: m2core.TFormDescriptor formDesc,
  3: TPricing pricing
}
struct TReservationDetailsPO {
  1: required TCompletedReservation reservation
}

/* seat maps */
enum TCabinType{
  BUSINESS = 0,
  ECONOMY = 1
}
struct TSeatRow {
  1: required list<TSeat> seats,
  2: string label
}
struct TSeatGrid {
  1: required list<TSeatRow> rows
  2: list<string> header,
  3: TCabinType cabinType,
  4: map<string,string> metaData
}
struct TAirplane {
  1: required string planeType,
  2: TSeatGrid seatGrid, /* Depricated */
  3: list<TSeatGrid> compartments
}
struct TSeatLegendLine{
  1: string seatGroup,
  2: m2core.TCurrency fee,
  3: m2core.TTextList desc
}
struct TSeatLegend{
  1: m2core.TTextList desc
  2: list<TSeatLegendLine> lines
}
struct TAirComponentSeatMap {
  1: required TAirComponent component,
  2: required TAirplane airplane, 
  3: TFlight flight,
  4: TSeatLegend legend
}
struct TPassengerSeatAssignment {
  1: required i32 paxId,
  2: TPassenger passenger,
  3: TSeat seat,
  4: i32 flightId
}
struct TAirComponentSeatAssignment {
  1: required i32 compIdx,
  2: required list<TPassengerSeatAssignment> passengers
}
struct TSeatMapDetailsForm {
  1: list<TAirComponentSeatAssignment> components
}
struct TSeatMapDetailsPO {
  1: required TSeatMapDetailsForm form,
  2: required list<TAirComponentSeatMap> seatMaps,
  3: TPricing pricing,
  4: bool seatsPreselected,
  5: m2core.TCurrency seatPreselectionAmount,
}
struct TChangeBookingDetailsPO {
  1: required TReservation reservation,
  2: TPricing pricing
}

enum TFlightInfoSearchFilter {
  NONE = 0,
  ARRIVALS = 1,
  DEPARTURES = 2
}

enum TFlightInfoSearchMode {
  BY_ROUTE = 0,
  BY_FLIGHT = 1
}

struct TFlightInfoSearchForm {
  1: TRoute route,
  2: m2core.TDate date,
  3: string flightNumber,
  4: string carrierCode,
  5: i32 daysForward,
  6: TFlightInfoSearchFilter filter,
  7: TFlightInfoSearchMode mode
}
struct TFlightInfoSearchPO {
  1: required TFlightInfoSearchForm form,
  2: m2core.TFormDescriptor formDesc
}
struct TFlightInfoPO {
  1: required TFlight flight
}
struct TFlightInfoListPO {
  1: required list<TFlightInfoGroup> groups
}
struct TFlightInfoSimpleListPO {
  1: required list<TFlightInfoPO> flights  
}
struct TAirportData {
  1: required map<string, TAirport> airports,
  2: list<string> origins,
  3: list<string> checkins,
  4: map<string, list<string>> connections,
  5: string hash,
  6: string defaultCountryCode
}
struct TFlightScheduleForm {
  1: required TRoute route,
  2: m2core.TDate date,
  3: bool week,
  4: string flightNumber,
  5: string carrierCode
}
struct TFlightScheduleSearchPO {
  1: required TFlightScheduleForm form,
  2: m2core.TFormDescriptor formDesc
}
struct TFlightScheduleListPO {
  1: list<TFlightSchedule> schedules,
  2: m2core.TDate startDate,
  3: m2core.TDate endDate,
  4: TRoute route,  
  5: bool prevDayAllowed,
  6: bool nextDayAllowed,
  7: bool prevWeekAllowed,
  8: bool nextWeekAllowed
}

//recall pnr
struct TRecallCriteriaForm {
  1: string option,
  2: string pnr,
  3: TRoute route,
  4: m2core.TDate departureDate,
  5: string firstName,
  6: string lastName,
  7: string email,
  8: bool guestCheckin
}
struct TRecallCriteriaPO {
  1: required TRecallCriteriaForm form,
  2: m2core.TFormDescriptor formDesc
}

struct TViewBookingsPO {
  1: required list<TReservation> reservations, //deprecated! use complete reservations
  2: list<TCompletedReservation> completeReservations
}

struct TViewIndividualBookingPO {
  1: required TReservation reservation
}

 struct TAcceptedCurrenciesPO {
  1: required list<m2core.TCurrencyOption> acceptedCurrencies
 }

struct TAvailabilityQuery {
  1: required i32 seq, 
  2: required m2core.TDate date, 
  3: i32 minusDays,
  4: i32 plusDays,
  5: string currencyCode,
  6: string fareBasisCode
}

struct TUserCredentialsForm {
  1: required m2core.TUserCredentials credentials,
  2: bool rememberMe
}

struct TUserLoginPO {
  1: required TUserCredentialsForm form,
  2: m2core.TFormDescriptor formDesc  
}

struct TViewBookingForm {
  1: required m2core.TPnr pnr
}

struct TProfilePO {
  1: required m2core.TProfile profile
}

struct TPasswordResetForm{
  1: required string email,
  2: required string confirmEmail
}

/* check-in */
struct TCheckinPassengerSelectionForm {
  1: required TPassenger passenger,
  2: required TFlight flight
}

struct TBoardingPassPO {
  1: required list<TBoardingPass> boardingPasses
}

/*
 * services
 */
service TAirportService
{
  //list<TAirportGroup> getAirportsGroupedByCountry(1: string from) throws (1: m2core.TServerException se),
  TAirportData getAirportsData() throws (1: m2core.TServerException se),
  TAirport getAirportByIata(1: required string iata) throws (1: m2core.TServerException se),
  TAirportInfo getAirportInfoByIata(1: required string iata) throws (1: m2core.TServerException se),
  list<TAirport> getDestinations(1: required string iata) throws (1: m2core.TServerException se),
  list<TAirport> getNearbyAirports(1: required m2core.TLocation location) throws (1: m2core.TServerException se)
}
service TBookingService
{
  TSearchCriteriaPO getSearchCriteriaPO() throws (1:m2core.TServerException se),
  
  void setSearchDetails(1: required TAvailabilityForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  /* deprecated. use version with query */
  TAvailabilityDetailsPO getAvailabilityPO(1: required i32 seq, 2: required m2core.TDate startDate, 3: m2core.TDate endDate) throws (1:m2core.TServerException se),
  
  TAvailabilityDetailsPO getAvailabilityDetailsPO(1: required TAvailabilityQuery query) throws (1:m2core.TServerException se),
  
  void selectFlight(1: required TSelectFlightReq request) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TBookingSummaryPO getBookingSummaryPO() throws (1: m2core.TServerException se),

  TPassengerDetailsPO getPassengerDetailsPO() throws (1: m2core.TServerException se),
  
  void setPassengerDetails(1: TPassengerDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TBaggageDetailsPO getBaggageDetailsPO() throws (1: m2core.TServerException se),
  
  void setBaggageDetailsPO(1: TBaggageDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),

  TAncillariesDetailsPO getAncillariesDetailsPO() throws (1: m2core.TServerException se),
  
  void setAncillariesDetailsPO(1: TAncillariesDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),

  TSeatMapDetailsPO getSeatMapDetailsPO() throws (1: m2core.TServerException se),
  
  void setSeatMapDetailsPO(1: TSeatMapDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TContactDetailsPO getContactDetailsPO() throws (1: m2core.TServerException se),
  
  void setContactDetails(1: TContactDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TPaymentDetailsPO getPaymentDetailsPO() throws (1: m2core.TServerException se),
  
  m2core.TPaymentResult setPaymentDetails(1: TPaymentDetailsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TReservationDetailsPO getConfirmationDetailsPO() throws (1: m2core.TServerException se),
  
  TRecallCriteriaPO getRecallCriteriaPO() throws (1:m2core.TServerException se),
  
  void setRecallCriteria(1: TRecallCriteriaForm form, 2: bool recallNow) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  
  TReservationDetailsPO getManagedBookingDetailsPO(1: TRecallCriteriaForm form) throws(1:m2core.TServerException se, 2: m2core.TValidationException ve)
}

service TFlightStatusService {
  TFlightInfoSearchPO getFlightInfoSearchPO() throws (1: m2core.TServerException se),
  void setFlightInfoSearch(1: required TFlightInfoSearchForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TFlightInfoListPO getFlightInfoListPO(1: required i32 shiftDay) throws (1: m2core.TServerException se),
  TFlightInfoSimpleListPO getFlightInfoSimpleListPO(1: required TFlightInfoSearchForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TFlightInfoPO getFlightInfoPO(1: required TFlight flight) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TFlightScheduleSearchPO getFlightScheduleSearchPO() throws (1: m2core.TServerException se),
  void setFlightScheduleSearch(1: required TFlightScheduleForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TFlightScheduleListPO getFlightSchedulePO(1: required i32 shiftWeek) throws (1: m2core.TServerException se)
}

service TProfileService {
  TUserLoginPO getLoginPO() throws (1: m2core.TServerException se),
  TViewBookingsPO getViewBookingsPO() throws (1: m2core.TServerException se),
  TProfilePO getProfilePO(1: required TUserCredentialsForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  void resetPassword(1: required TPasswordResetForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve)
  //updateProfile(TProfile)
  //updateContact(i32 index, TContact contact)
}

service TOperationService {
  TAcceptedCurrenciesPO getAcceptedCurrenciesPO() throws (1: m2core.TServerException se)
}

service TCheckinService {
  TReservationDetailsPO getCheckinBookingDetailsPO(1: TRecallCriteriaForm form) throws(1:m2core.TServerException se, 2: m2core.TValidationException ve)
  void setCheckinPassengerSelection(1: required TCheckinPassengerSelectionForm form) throws (1: m2core.TServerException se, 2: m2core.TValidationException ve),
  TBoardingPassPO getBoardingPasses() throws (1: m2core.TServerException se)
}
