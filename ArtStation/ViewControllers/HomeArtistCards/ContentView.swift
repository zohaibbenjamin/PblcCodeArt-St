//
//  ContentView.swift
//  ArtStation
//
//  Created by Apple on 07/06/2021.
//


import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

protocol ProtocolShowDetailArtist {
    func showDetailOfArtist(dataObj:GetArtistDetailApiResponse)
}

protocol ProtocolAddRemoveFavouriteArtist{
    func addToFavouriteArtistList(id:Int,categoryId:Int,name:String?,role_id:Int)
}

struct CardData {
    let priceString : String
    let artistName : String
    let noOfPackages : String
    let imgOfArtist : String
    let specialities: [String]?
    let isRange:String
}

enum Test {
    
    static var DataObjListOfCards = [
        CardData.init(priceString: "1200", artistName: "Young Chin", noOfPackages: "5", imgOfArtist: "artist3", specialities: ["HI","Bye"], isRange: ""),
        CardData.init(priceString: "800", artistName: "Zobarick Chan", noOfPackages: "34", imgOfArtist: "artist2", specialities: ["HI","Bye"], isRange: ""),
        CardData.init(priceString: "2000", artistName: "Deba Kika", noOfPackages: "100", imgOfArtist: "artist1", specialities: ["HI","Bye"], isRange: ""),
        CardData.init(priceString: "3459.89", artistName: "Donajin Sibachinonjj", noOfPackages: "2", imgOfArtist: "artist2", specialities: ["HI","Bye"], isRange: ""),
        CardData.init(priceString: "9900.00", artistName: "DinkaKingZong A Jinaj", noOfPackages: "10", imgOfArtist: "artist3", specialities: ["HI","Bye"], isRange: ""),
        CardData.init(priceString: "16700.87", artistName: "Ui dIOif oei idoj ", noOfPackages: "", imgOfArtist: "artist4", specialities: ["Google","Hello","Afghanistan","Yahoo"], isRange: "")
    ]
    
    static var noOfDemos=(DataManager.ArtistCards?.list?.count ?? 0)
    static var testDemos: [DemoCard.Demo] {
        noOfDemos=(DataManager.ArtistCards?.list?.count ?? 0)
        return (0 ..< noOfDemos).map {
            //  return DemoCard.Demo.init(colrString:Test.colors[$0 % Test.colors.count],priceString:( DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom ?? 0).description, artistName: DataManager.ArtistCards?.list?[$0 % noOfDemos].name ?? "", noOfPackages:DataManager.ArtistCards?.list?[$0 % noOfDemos].packageCount?.description ?? "0", imgOfArtist: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistImageOrReturnDefault().profileImage ?? "artist1",strtinPrice:"Starting Price",packages: "Packages",artistData: DataManager.ArtistCards?.list?[$0 % noOfDemos])
            if DataManager.getLanguage=="ar"
            {
                return DemoCard.Demo.init(colrString: Test.colors[$0 % Test.colors.count], priceString: ( DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom?.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f",DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom ?? 0.0) : DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom?.description) ?? "", artistName: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistInfo().stageName_ar ?? "", noOfPackages: DataManager.ArtistCards?.list?[$0 % noOfDemos].packageCount?.description ?? "0", imgOfArtist: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistImageOrReturnDefault().coverImage ?? "artist1", strtinPrice: "ابتداءً من", packages: "عدد الباقات ", artistData: DataManager.ArtistCards?.list?[$0 % noOfDemos], priceCurrency: Utils.localizedText(text: "SAR"), specialities: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistTalentSpecialities(),
                                          isRange:DataManager.ArtistCards?.list?[$0 % noOfDemos].getRange() ?? "")
            }
            else
            {
                debugPrint("ArtistImageTest",DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistImageOrReturnDefault().coverImage ?? "artist1")
                
                return DemoCard.Demo.init(colrString: Test.colors[$0 % Test.colors.count], priceString: ( DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom?.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f",DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom ?? 0.0) : DataManager.ArtistCards?.list?[$0 % noOfDemos].startingFrom?.description) ?? "" , artistName: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistInfo().stageName ?? "", noOfPackages: DataManager.ArtistCards?.list?[$0 % noOfDemos].packageCount?.description ?? "0", imgOfArtist: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistImageOrReturnDefault().coverImage ?? "artist1", strtinPrice: "Starting Price", packages: ((DataManager.ArtistCards?.list?[$0 % noOfDemos].packageCount ?? 0) > 1 ? "Packages" : "Package"), artistData: DataManager.ArtistCards?.list?[$0 % noOfDemos], priceCurrency: "SAR", specialities: DataManager.ArtistCards?.list?[$0 % noOfDemos].getArtistTalentSpecialities(), isRange: DataManager.ArtistCards?.list?[$0 % noOfDemos].getRange() ?? ""
                )
            }
            
        }
    }
    static let colors: [Color] = [.white]
    static let width: CGFloat = UIScreen.main.bounds.width-40
    static let height: CGFloat = UIScreen.main.bounds.height-120
    static let cardSize = CGSize(width: Test.width, height: Test.height)
}

struct DemoCard: View {
    
    struct Demo {
        let colrString : Color
        let priceString : String
        let artistName : String
        let noOfPackages : String
        let imgOfArtist : String
        let strtinPrice : String
        let packages : String
        let artistData : GetArtistDetailApiResponse?
        let priceCurrency : String
        let specialities: [String]?
        let isRange:String
    }
    
    static var delegatePushViewCOntroller:ProtocolShowDetailArtist?
    static var delegateAddRemoveArtistFavourtieList: ProtocolAddRemoveFavouriteArtist?
    
    let demo: Demo
    
    var body: some View {
        
        ZStack (alignment:(DataManager.getLanguage == Language.arabic.rawValue ? .trailing:.leading) ) {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(demo.colrString)
                .shadow(radius: 5)
            
            VStack
            {
                
                if #available(iOS 14.0, *) {
                    WebImage(url: URL(string:"\(ConfigurationManager.shared.getBaseURLImage().absoluteString)\(demo.imgOfArtist)"))
                    // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                    //  RemoteImage(url: "\(ConfigurationManager.shared.getBaseURLImage().absoluteString)\(demo.imgOfArtist)")
                        .resizable()
                        .cornerRadius(15)
                    //.aspectRatio(contentMode: .fit)
                        .frame(width: Test.width, height: Test.width, alignment: .center)
                        .layoutPriority(1)
                } else {
                    // Fallback on earlier versions
                    
                    Image.init("placeholder_artist")
                        .resizable()
                        .cornerRadius(15)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Test.width, height: Test.width, alignment: .center)
                        .layoutPriority(1)
                }
            
                HStack {
                    
                    if DataManager.getLanguage=="ar"
                    {

                        VStack (spacing:5){
                            HStack {
                                Text("متوسط سعر الساعة")
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.gray)
                                        .font(Font.custom( "Almarai-Regular", size: 16.0))
                                        .minimumScaleFactor(0.5)
                                        .fixedSize()
                                    .frame(alignment: .leading)
                            }.frame(width:Test.width/2, alignment: .leading)
                            
                            HStack{
                                if(demo.isRange == "2"){
                                Text("للساعة")
                                       .fontWeight(.bold)
                                        .foregroundColor(Color.init(hex: "#E8008A"))
                                        .multilineTextAlignment(.leading)
                                        .font(Font.custom( "Almarai-Bold", size: 20.0))
                                        .minimumScaleFactor(0.5)
                                        .fixedSize()
                                    .frame( alignment: .leading)
                                }
                                
                                Text("\(Utils.localizedText(text: demo.priceCurrency)) \(demo.priceString )")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(hex: "#E8008A"))
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom( "Almarai-Bold", size: 20.0))
                                    .minimumScaleFactor(0.5)
                                    .fixedSize()
                                    .frame(alignment: .leading)
                            }.frame(width:Test.width/2, alignment: .leading)
                        }
                     
                        
                        
                        Text(demo.artistName)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(hex: "#4B4B4B"))
                            .font(Font.custom( "Almarai-Bold", size: 20.0))
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                            .frame(minWidth: 100, idealWidth: 120, maxWidth: Test.width/2, minHeight: 70, idealHeight: 70, maxHeight: 70, alignment: .trailing)
                    }
                    else
                    {
                        VStack (alignment:.leading){
                     
                            HStack {
                                Text("Approx price")
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.gray)
                                        .font(Font.custom( "Poppins-Regular", size: 16.0))
                                        .minimumScaleFactor(0.5)
                                        .fixedSize()
                                    .frame(alignment: .leading)
                            }.frame(width:Test.width/2 ,alignment: .leading)
                            
                            HStack{

                                Text("\(Utils.localizedText(text: demo.priceCurrency)) \(demo.priceString)")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(hex: "#E8008A"))
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom( "Poppins-Medium", size: 20.0))
                                    .lineLimit(2)
                                    .fixedSize()
                                

                                if(demo.isRange.elementsEqual("2")){
                                Text("per hour")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.init(hex: "#E8008A"))
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom( "Poppins-Medium", size: 16.0))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                    .fixedSize()
                                    .padding(.leading,-7)
                                }
                            }.frame(width:Test.width/2 ,alignment: .leading)
                        }
                        
                        Text(demo.artistName)
                            .fontWeight(.bold)
                            .foregroundColor(Color.init(hex: "#4B4B4B"))
                            .font(Font.custom( "Poppins-Medium", size: 20.0))
                            .lineLimit(2)
                            .multilineTextAlignment(.trailing)
                            .frame(minWidth: 100, idealWidth: 120, maxWidth: Test.width/2, minHeight: 70, idealHeight: 70, maxHeight: 100, alignment: .trailing)
                    }
                }
                .frame(width: Test.width-40, height: 80, alignment: .leading)
                .lineLimit(1)
                
                HStack(spacing: 5){
                    if DataManager.getLanguage=="ar"
                    {
                        
                        //                            Text("\(Utils.localizedText(text: demo.priceCurrency)) \(demo.priceString)")
                        //                                .fontWeight(.bold)
                        //                                .foregroundColor(Color.init(hex: "#E8008A"))
                        //                                .multilineTextAlignment(.leading)
                        //                                .font(Font.custom( "Almarai-Bold", size: 20.0))
                        //                                .minimumScaleFactor(0.5)
                        //                                .frame(width: Test.width/2, height: 40, alignment: .leading)
                        
                        //                            Text("\(demo.noOfPackages) \(demo.packages)")
                        //                                .fontWeight(.light)
                        //                                .foregroundColor(Color.init(hex: "#4B4B4B"))
                        //                                .font(Font.custom( "Almarai-Regular", size: 14.0))
                        //                                .minimumScaleFactor(0.5)
                        //                                .multilineTextAlignment(.trailing)
                        //                                .frame(minWidth: 100, idealWidth: 120, maxWidth: Test.width/2, minHeight: 70, idealHeight: 70, maxHeight: 70, alignment: .trailing)
                        
                        
                            ForEach(demo.specialities ?? [], id: \.self) {item in
                                SpecialitiesView(specialityTitl: item, fontTitle: "Almarai-Bold", fontSize: 12)
                                    .fixedSize()
                            }.scaledToFit()
                        
                    }
                    else
                    {
                        //                            Text("\(demo.priceString) \(Utils.localizedText(text: demo.priceCurrency))")
                        //                                .fontWeight(.bold)
                        //                                .foregroundColor(Color.init(hex: "#E8008A"))
                        //                                .multilineTextAlignment(.leading)
                        //                                .font(Font.custom( "Poppins-Medium", size: 20.0))
                        //                                .minimumScaleFactor(0.5)
                        //                                .frame(width: Test.width/2, height: 40, alignment: .leading)
                        
                        //
                        //                            Text("\(demo.noOfPackages) \(demo.packages)")
                        //                                .fontWeight(.light)
                        //                                .foregroundColor(Color.init(hex: "#4B4B4B"))
                        //                                .font(Font.custom( "Poppins-Regular", size: 14.0))
                        //                                .minimumScaleFactor(0.5)
                        //                                .multilineTextAlignment(.trailing)
                        //                                .frame(minWidth: 100, idealWidth: 120, maxWidth: Test.width/2, minHeight: 70, idealHeight: 70, maxHeight: 70, alignment: .trailing)
                        
                        
    
                            ForEach(demo.specialities ?? [], id: \.self) {item in
                                SpecialitiesView(specialityTitl: item, fontTitle: "Poppins-semiBold", fontSize: 10)
                                    .fixedSize()
                            }.scaledToFit()
                    }
                }
                .frame(width: Test.width-20, height: 30, alignment: DataManager.getLanguage == Language.arabic.rawValue ? .trailing: .leading)
                .offset(x: 0, y: -16)
                .lineLimit(1)
            }
            .layoutPriority(1)
            .cornerRadius(22)
            
            ZStack(alignment: .topLeading) {
                Button {
                    DemoCard.delegateAddRemoveArtistFavourtieList?.addToFavouriteArtistList(id: demo.artistData?.id ?? 0, categoryId: demo.artistData?.category_id ?? 0, name: demo.artistName, role_id: demo.artistData?.role_id ?? 0)
                } label: {
                    Image("favouritPin")
                        .resizable()
                        .rotationEffect(Angle(degrees: DataManager.getLanguage == Language.arabic.rawValue ? 90 : 0))
                }
            }.frame(width: 50, height: 50, alignment: .top)
                .offset(x: (DataManager.getLanguage == Language.arabic.rawValue
                            ? -10: 10), y: -180)
                .layoutPriority(1)
        }
        .onTapGesture {
            DemoCard.delegatePushViewCOntroller?.showDetailOfArtist(dataObj: demo.artistData!)
        }
        .offset(x: 0, y: 40)
        .padding(.bottom, 115)
        .padding(.top,25)
    }
}

extension DemoCard: ConfigurableCard {
    static func new(data: Demo?) -> DemoCard {
        guard let demoValue = data else { return DemoCard(demo: .default) }
        return DemoCard(demo: demoValue)
    }
}

extension DemoCard.Demo: DefaultValue {
    static var `default`: DemoCard.Demo {
       // return .init(colrString: .clear, priceString: "", artistName: "", noOfPackages: "", imgOfArtist: "",strtinPrice: "",packages: "",artistData: GetArtistDetailApiResponse.init(name: "", phone: "", email: "", id: 0, city: "", dob: "", deviceToken: "", status: "", packages: [Package](), artistInfo: [ArtistInfo](), artistImages: [ArtistImage](), packageCount: 0, startingFrom: 0),)

        return .init(colrString: .clear, priceString: "", artistName: "", noOfPackages: "", imgOfArtist: "", strtinPrice: "", packages: "", artistData: GetArtistDetailApiResponse.init(name: "", phone: "", email: "", type: "", city: "", DOB: "", deviceToken: "", device_type: "", status: "", lang: "", verified: "", userType: "", role_id: 0, id: 0, category_id: 0, city_id: 0, packageCount: 0, startingFrom: 0, packages: [Package](), artist_info: [ArtistInfo](), artist_images: [ArtistImage](), artist_talent: [Artist_Talent](),artist_intro: [Artist_Intro](), band: false, solo: false, allowPush: false, rating: 0.0), priceCurrency: "", specialities: nil, isRange: "")
    }
}

struct ContentView: View {
    var body: some View {
        ContentView_Previews.previews
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
//                DemoCard(demo: DemoCard.Demo(colrString: Color.white, priceString: "1000000", artistName: "Hamid Zaib Hamid Zaib", noOfPackages: "3", imgOfArtist: "artist1", strtinPrice: "0", packages: "2", artistData: nil, priceCurrency: "100", specialities: ["Google","Hello","Afghanistan","Yahoo"], isRange: "2"))
                
                            RGStack<DemoCard>(data: Test.testDemos,
                                             size: Test.cardSize,
                                             gapDistance: 20,
                                             minScaleForBackCard: 0.5)
            }
        }
    }
}


struct SpecialitiesView:View {
    @State var specialityTitl:String
    @State var fontTitle:String
    @State var fontSize: Int
    
    var body: some View{
       Text(specialityTitl)
            .font(Font.custom(fontTitle, size: CGFloat(fontSize)))
            .padding(.horizontal , 12)
            .padding(.vertical,9)
            .background(
                Capsule().strokeBorder(Color.gray, lineWidth: 1).opacity(0.3))
    }
}
//
//struct SpecialitiesView_Preview: PreviewProvider{
//    static var previews: some View{
//        SpecialitiesView(specialityTitl: "label")
//            .preferredColorScheme(.dark)
//            .previewLayout(.sizeThatFits)
//    }
//}

