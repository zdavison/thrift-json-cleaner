namespace java com.mttnow.common.api

const string HEADER_APP_INFO = "X-Client-App"
const string HEADER_APP_ID = "X-Client-App-Id"
const string HEADER_APP_LANG = "X-ClientApp-Lang"
const string HEADER_APP_ERROR = "X-Client-Error"
const string HEADER_HTTP_CHUNKED = "X-HTTPChunked"
const string PARAM_APP_ID = "appid";
const string HEADER_APP_DEBUG = "X-Client-Debug"
const string HEADER_APP_LOCATION = "X-Location"
const string PARAM_CAMPAIGN = "c"
const string PARAM_LANG = "lang"
const i32 ERROR_UNSUPPORTED_VERSION = 510
const i32 ERROR_SERVER_MAINTENANCE = 511
const i32 ERROR_OLD_VERSION = 512


struct TDate {
  1: required i32 date
}
struct TTime {
  1: required i32 time
}
struct TDateTime {
  1: required TDate date,
  2: required TTime time
}
struct TPeriod{
	1: i32 days,
	2: i32 hours,
	3: i32 minutes,
	4: i32 daysDiff
}
struct TCurrency {
  1: required string code,
  2: required double amount
}
struct TCurrencyOption {
  1: required string code,
  2: required string name,
  3: required i32 decimalPlaces
}
struct TTextLine {
  1: string meta,
  2: string caption,
  3: string text,
  4: string link,
  5: string metaId
}
struct TTextList {
  1: list<TTextLine> lines
}
struct TFieldNumber {
  1: bool req,
  2: i32 minValue,
  3: i32 maxValue,
  4: list<i32> options,
  5: list<string> labels,
  6: list<TCurrency> amounts,   
  7: bool disabled,
  8: string label
}
struct TFieldDate {
  1: bool req,
  2: TDate minValue,
  3: TDate maxValue,
  4: list<TDate> options,
  5: list<string> labels,
  6: list<TCurrency> amounts,  
  7: bool disabled,
  8: string label
}
struct TFieldText {
  1: bool req,
  2: i32 minLength,
  3: i32 maxLength,
  4: string regExpPattern,
  5: list<string> options,
  6: list<string> labels,
  7: list<TCurrency> amounts,
  8: bool disabled,
  9: string label  
}
struct TFormDescriptor {
  1: map<string, TFieldNumber> numberFields,
  2: map<string, TFieldDate> dateFields,
  3: map<string, TFieldText> textFields
}
enum TCmsTileDisplay {
  NONE = 0,
  ONCE = 1,
  ONCE_PER_SESSION = 2,
  ALWAYS = 3
}
struct TCmsTile {
  1: required string path,
  2: required string model,
  3: required string template,
  4: required TCmsTileDisplay display
}
struct TCmsTiles {
  1: required list<TCmsTile> tiles
}
struct TVersion {
  1: required i32 number
}
struct TUserCredentials {
  1: required string username,
  2: required string password
}
struct TAppInfo {
  1: required string os
  2: required string deviceId
  3: required TVersion version
  4: TUserCredentials credentials
  5: list<string> cmsTemplates
}
struct TCountry {
  1: required string code,
  2: string name,
  3: i32 phoneCode,
  4: optional string iso3Code
}
struct TCity {
  1: required string name,
  2: string id,
  3: string countryCode,
  4: TCountry country
}
struct TLocation {
  1:i32 lat, 
  2:i32 lng
}
struct TMsg {
  1: required string code,
  2: list<string> arguments
}
enum TPricingTableRowMeta{
  TOTAL = 0,
  FEE = 1,
  CARD_FEE = 2,
  FARE = 3,
  ANCILLARY = 4,
  UNDEF = 5,
  DISCOUNT = 6
}
struct TPricingTableRow {
  1: string label,
  2: TCurrency value,
  3: string style,
  4: TPricingTableRowMeta metaData,
  5: string valueLabel
}
struct TPricingTable {
  1: string header,
  2: list<TPricingTableRow> rows
}
struct TAppMessage {
  1: required TTextLine content
  2: string link
  3: i32 period
}

struct TAddress {
  1: string address1,
  2: string address2,
  3: string address3,
  4: string city,
  5: string state,
  6: TCountry country,
  7: string postCode
}

struct TCreditCard {
  1: string cardType,
  2: string cvv,
  3: string cardNumber,
  4: string cardHolder,
  5: TDate expiryDate,
  6: string bankName,
  7: TDate startDate,
  8: string issueNumber,
  9: TAddress address
}
struct TEncryptedCreditCard {
  1: required string mask,
  2: required string cardType,
  3: string payload,
  4: bool active,
  5: string message
}
struct TPhone {
  1: required string number,
  2: string info
}
struct TImage {
  1: required string url,
  2: string alt,
  3: string small
}
struct TKeyValue {
  1: required string key,
  2: required string value
}


struct TUIModule {
  1: required bool enabled,
  2: required string id,
  3: string url
}

struct TCulture {
  1: required string code,
  2: TCountry country,
  3: string languageCode,
  4: string languageName
}

struct TAppConfig {
  1: required list<TUIModule> modules,
  2: required list<string> languages,
  3: required list<string> campaigns,
  4: TVersion latestVersion,
  5: required TVersion endpointVersion,
  6: required string endpointContext,  
  7: list<TAppMessage> messages,
  8: string deviceId,
  9: required map<string,string> cacheHashes,
  10: TCmsTiles cms,
  11: map<string,TDateTime> cacheTimestamps,
  12: list<TCulture> cultures //superset of "languages"
}
struct TWeather {
  1: TDateTime dateTime,
  2: string dateTimeStr
  3: string desc,
  4: TImage image,
  5: i32 low,
  6: i32 high
}

struct TLoyaltyData{
  1: required string id,
  2: string level,
  3: string code
}

struct TContact {
  1: string title,
  2: string firstName,
  3: string lastName,
  4: string phone,
  5: string phone2,
  6: string address1,
  7: string address2,
  8: string city,
  9: string state,
  10: TCountry country,
  11: string postCode,
  12: string email,
  13: bool isTravelling,
  14: string avatar,
  15: TDate dob,
  16: string suburb,
  17: string address3
  18: list<TLoyaltyData>loyltyData

}

struct TProfile {
  1: string id,
  2: TContact contact,
  3: string language,
  4: list<TEncryptedCreditCard> cards,
  5: list<TContact> buddies,
  6: string cultureCode,
  7: string number
}

enum TPaymentStatus {
  NONE = 0,
  INPROGRESS = 1,
  COMPLETED_SUCCESS = 2,
  COMPLETED_ERROR = 3,
  CANCELLED = 4,
  DECLINED = 5
}

struct TPaymentResult {
  1: required TPaymentStatus status,
  2: TEncryptedCreditCard creditCard
}

struct TPnr {
  1: string locator
}

enum TErrorCode {
  UNKNOWN = 0,
  SESSION_EXPIRED = 1,
  EXTERNAL_ERROR = 2,
  UNSUPPORTED_VERSION = 3,
  CUSTOM_ERROR = 4,
  AUTH_ERROR = 5,
  SESSION_EXPIRED_REPEAT = 6
}
enum TExceptionType {
  FATAL = 0,
  WARNING = 1,
  NOT_SUPPORTED = 2
}
exception TServerException {
  1: required TErrorCode errorCode,
  2: required string message,
  3: list<string> details
}
struct TFieldError {
  1: required string field,
  2: required string message
}
struct TError {
  1: required TExceptionType type,
  2: required string message
}

exception TValidationException {
  1: list<TError> globalErrors,
  2: list<TFieldError> fieldErrors
}

struct TContentPO {
  1: TTextLine header,
  2: TTextList content,   //deprecated. use content lines
  3: list<TTextLine> contentLines
}

service TCountryService
{
  list<TCountry> getCountries() throws (1: TServerException se),
  TCountry getCountry(1: required string code) throws (1: TServerException se),
}

service TApplicationService 
{
  TAppConfig getConfig(1: TAppInfo app) throws (1: TServerException se)
  void registerPushEvents(1: string token, 2: map<string,string> events) throws (1: TServerException se)
  void unregisterPushEvents() throws (1: TServerException se)
}
service TWeatherService {
  list<TWeather> getWeatherByLocation(1:required i32 lat, 2:required i32 lng) throws (1: TServerException se),  //deprecated. use getWeatherByLoc
  list<TWeather> getWeatherByLoc(1:required TLocation location) throws (1: TServerException se),  
  list<TWeather> getWeatherById(1:required string id) throws (1: TServerException se)
}

service TContentService {
  TContentPO getContent(1: required string contentId) throws (1: TServerException se)
}
