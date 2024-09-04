//  ContentView.swift
//  Billions
//
//  Created by Muhammad Nouman on 04/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false
    @StateObject private var viewModel = ContentViewModel()
    let darkGray = Color("primaryGray")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                bannerView
                titleView
                buttonsView
                descriptionView
                actionsView
                seasonsView
                episodesView
            }
        } .background(Color.black.edgesIgnoringSafeArea(.all))
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription))
            }
    }
    
    var bannerView: some View {
        ZStack(alignment: .topLeading) {
            Image("billions_banner")
                .resizable()
                .scaledToFit()
            
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                
                Spacer()
                Button(action: {
                    // Action for share button
                }) {
                    Image(systemName: "icloud.and.arrow.up")
                        .foregroundColor(.white)
                        .font(.title2)
                }.padding()
                Button(action: {
                    // Action for share button
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }.padding()
        }
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.tvShow?.name ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("2017 | \(viewModel.seasonCount) Seasons | R")
                .foregroundColor(.gray)
                .fontWeight(.medium)
        }.padding(.top, -30)
    }
    
    var buttonsView: some View {
        HStack(spacing: 20) {
            Button(action: {
                // Action for play button
            }) {
                Label("Play", systemImage: "play.fill")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
            }.background(Color.orange)
                .cornerRadius(8)
            
            Button(action: {
                // Action for trailer button
            }) {
                Label("Trailer", systemImage: "film")
                    .foregroundColor(.white)
                    .padding()
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }.background(darkGray)
                .cornerRadius(8)
        }
    }
    
    var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.tvShow?.overview ?? "")
                .foregroundColor(.gray)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(isExpanded ? nil : 3)
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? "Read Less" : "Read More")
                    .foregroundColor(.orange)
            }
        }
    }
    
    var actionsView: some View {
        HStack(spacing: 40) {
            VStack {
                Image(systemName: "plus.circle")
                    .font(.title)
                Text("Watchlist")
                    .font(.caption)
            }
            
            VStack {
                Image(systemName: "hand.thumbsup")
                    .font(.title)
                Text("I like it")
                    .font(.caption)
            }
            
            VStack {
                Image(systemName: "hand.thumbsdown")
                    .font(.title)
                Text("I don't like it")
                    .font(.caption)
            }
        }
        .foregroundColor(.gray)
        .padding(.vertical)
    }
    
    var seasonsView: some View {
        HStack(spacing: 30) {
            HStack {
                Text("SEASON 1")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Spacer()
                Text("|").foregroundColor(.gray)
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                .overlay(Rectangle().frame(height: 3).foregroundColor(.white), alignment: .bottom)
            
            HStack {
                Text("SEASON 2")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                Spacer()
                Text("|").foregroundColor(.gray)
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            HStack {
                Text("SEASON 3")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        }.frame(maxWidth: .infinity)
    }
    
    var episodesView: some View {
        ForEach(Array(viewModel.episodes.enumerated()), id: \.element.id) { index, episode in
            HStack {
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .padding()
                
                Image(systemName: "")
                    .resizable()
                    .frame(width: 100, height: 50)
                    .cornerRadius(4)
                
                Text(viewModel.episodeTitle(index: index))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.down.square")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(height: 120)
            .background(darkGray.edgesIgnoringSafeArea(.all))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

