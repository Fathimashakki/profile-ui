//
//  ContentView.swift
//  profile ui
//
//  Created by Shakki on 20/05/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    var body: some View {
        ProfileImageView()
    }
}

struct ProfileImageView: View {
    @State private var profileImage: Image? = nil
    @State private var showOptions = false
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                        )
                }

                Button(action: {
                    showOptions = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.blue)
                        .background(Color.white.clipShape(Circle()))
                        .clipShape(Circle())
                }
                .offset(x: 5, y: 5)
                .confirmationDialog("Profile Options", isPresented: $showOptions, titleVisibility: .visible) {
                    Button("Choose from Photos") {
                        showImagePicker = true
                    }

                    Button("Crop Image") {
                       
                    }

                    Button("Save Image") {
                       
                    }

                    Button("Cancel", role: .cancel) {}
                }
            }
            .padding()
        }
        .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    imageData = data
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
