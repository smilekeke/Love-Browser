//
//  SegmentedView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/12.
//

import SwiftUI

struct SegmentedView: View {
    
    @ObservedObject var urlSessionManager = URLSessionManager()
    @State var array: [SegmentModel]

    var clickSegmentItem: ([ListModel]) -> Void

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack {
                
                ForEach($urlSessionManager.results, id: \.label) { $model in
                    Button  {
                        changeLinearGradient()
                        model.isSelected = true
                        clickSegmentItem(model.items ?? [])

                    } label: {

                        VStack {

                            Text(model.label)
                                .foregroundColor(Color.lb_segment)
                                .font(.system(size: 16))
                            LinearGradient(colors: [Color.blue], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 30, y: 0))
                                .frame(height: 3)
                                .opacity(model.isSelected ?? false ? 1 : 0)
                                .padding(.top, -2)


                        }

                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading, 10)

                }

            }

        }
        .padding(.top, 10)
        .padding(.leading, 20)
        .padding(.trailing, 20)

    }
    
    func changeLinearGradient() {
     
        for model in urlSessionManager.results {
            var result = model
            result.isSelected = false
            self.array.append(result)
        }
        
        urlSessionManager.results = array
    }
}


//struct SegmentedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentedView(results: []) { model in
//            
//        }
//    }
//}
