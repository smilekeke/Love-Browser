//
//  SegmentedView.swift
//  Love Browser
//
//  Created by 豆子 on 2023/4/12.
//

import SwiftUI

struct SegmentedView: View {
    
    @EnvironmentObject var appSettings: AppSetting
    @Binding var segmentModels: [SegmentModel]
    @State var array: [SegmentModel]

    var clickSegmentItem: (SegmentModel) -> Void

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack {
                
                ForEach($segmentModels, id: \.label) { $model in
                    Button  {
                        
                        changeLinearGradient(label: model.label)
                        clickSegmentItem(model)

                    } label: {
 
                        VStack {

                            Text(model.label)
                                .foregroundColor(model.isSelected ?? false ? (appSettings.darkModeSettings ?  Color.lb_segment_selected : Color.white) : (appSettings.darkModeSettings ? Color.lb_segment : Color(white: 0.8)))
                                .font(.system(size: 16))
                            
                            Rectangle()
                                .foregroundColor(Color.blue)
                                .frame(height: (3.0))
                                .opacity(model.isSelected ?? false ? 1 : 0)
                                .padding(.top, -2)
                        }

                    }
//                    .background(Color.red)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading, 10)

                }

            }

        }
        .padding(.top, 8)
        .padding(.leading, 20)
        .padding(.trailing, 20)

    }
    
    func changeLinearGradient(label: String) {
    
        array.removeAll()
        
        for model in segmentModels {
            
            var result = model
            
            if result.label == label {
                
                result.isSelected = true
            } else {
                result.isSelected = false
            }
            
            array.append(result)
        }
        segmentModels = array
    }
}


//struct SegmentedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentedView(results: []) { model in
//            
//        }
//    }
//}
