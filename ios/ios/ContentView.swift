//
//  ContentView.swift
//  ios
//
//  Created by Matthias Wallner-Géhri on 25.08.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var rebrickableAPI = RebrickableAPI.shared
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var sets: [RebrickableSet] = []
    @State private var themes: [RebrickableTheme] = []
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            // Original Items Tab
            NavigationView {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Items")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .tabItem {
                Label("Items", systemImage: "list.bullet")
            }
            .tag(0)
            
            // LEGO Sets Tab
            NavigationView {
                VStack {
                    if rebrickableAPI.isLoading {
                        ProgressView("Loading LEGO sets...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(sets) { set in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(set.name)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(set.year)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("Set #\(set.setNum)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(set.numParts) parts")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                        .searchable(text: $searchText, prompt: "Search LEGO sets")
                        .onSubmit(of: .search) {
                            Task {
                                await searchSets()
                            }
                        }
                    }
                }
                .navigationTitle("LEGO Sets")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Featured") {
                            Task {
                                await loadFeaturedSets()
                            }
                        }
                    }
                }
                .task {
                    await loadFeaturedSets()
                }
            }
            .tabItem {
                Label("Sets", systemImage: "cube.box")
            }
            .tag(1)
            
            // Themes Tab
            NavigationView {
                VStack {
                    if rebrickableAPI.isLoading && themes.isEmpty {
                        ProgressView("Loading themes...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(themes) { theme in
                            HStack {
                                Text(theme.name)
                                    .font(.body)
                                Spacer()
                                if theme.parentId != nil {
                                    Image(systemName: "arrow.turn.down.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Themes")
                .task {
                    await loadThemes()
                }
            }
            .tabItem {
                Label("Themes", systemImage: "folder")
            }
            .tag(2)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: rebrickableAPI.lastError) { error in
            if let error = error {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }

    // MARK: - Original Methods
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    // MARK: - API Methods
    private func loadFeaturedSets() async {
        do {
            let response = try await rebrickableAPI.getFeaturedSets(limit: 20)
            await MainActor.run {
                self.sets = response.results
            }
        } catch {
            // Error handling is done through the API's published lastError
        }
    }
    
    private func searchSets() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            await loadFeaturedSets()
            return
        }
        
        do {
            let response = try await rebrickableAPI.searchSets(name: searchText, limit: 20)
            await MainActor.run {
                self.sets = response.results
            }
        } catch {
            // Error handling is done through the API's published lastError
        }
    }
    
    private func loadThemes() async {
        do {
            let response = try await rebrickableAPI.getThemes()
            await MainActor.run {
                self.themes = Array(response.results.prefix(50)) // Limit to first 50 for performance
            }
        } catch {
            // Error handling is done through the API's published lastError
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
