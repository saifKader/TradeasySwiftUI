import SwiftUI
import CoreData
import SwiftUISnackbar
struct NotificationView: View {
    @State private var myList: [NotificationModel] = []
    @State private var deletedNotification: NotificationModel?
    @State private var showAlert: Bool = false
    let viewModel = NotificationViewModel()
    @Environment(\.managedObjectContext) private var managedContext
    @EnvironmentObject var navigationController: NavigationController
    @State private var snackbarMessage: String = ""
    @State private var showSnackbar: Bool = false
    let notificationApi = NotificationAPI()
    @State private var deletedIndex: Int?

    func deleteNotification(at indexSet: IndexSet) {
        if let index = indexSet.first {
            deletedNotification = myList[index]
            deletedIndex = index
            myList.remove(at: index)
            showSnackbarWith(message: "Notification Deleted")
        }
    }

    func showSnackbarWith(message: String) {
        snackbarMessage = message
        showSnackbar = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if self.showSnackbar {
                self.confirmDeleteNotification()
            }
            self.showSnackbar = false
        }
    }

    func confirmDeleteNotification() {
        if let deleted = deletedNotification {
            print(deleted.id)
            Task {
                do {
                    let req = DeleteNotificationReq(id: deleted.id)
                    try await notificationApi.deleteNotification(req)
                } catch {
                    print("Error deleting notification: \(error)")
                }
            }
            showAlert = false
        }
    }

    func undoDelete() {
        if let deleted = deletedNotification, let index = deletedIndex {
            myList.insert(deleted, at: index)
            deletedNotification = nil
            deletedIndex = nil
        }
        self.showSnackbar = false
    }

    var body: some View {
        VStack {
            List {
                ForEach(myList.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "hammer.fill")
                                .foregroundColor(Color("app_color"))
                                .imageScale(.large)
                            Text(myList[index].title!)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("font_color"))
                            Spacer()
                            Text(getTimeAgo(time: myList[index].date!)!)
                                .font(.caption)
                                .foregroundColor(Color.gray)
                        }
                        Text(myList[index].description!)
                            .font(.subheadline)
                            .foregroundColor(Color("font_color"))
                            .lineLimit(2)
                        
                    }
                    .padding()
                    .background(Color("card_color"))
                    //.cornerRadius(4)
                    //.shadow(color: .gray, radius: 2, x: 0, y: 2)
                }
                .onDelete(perform: deleteNotification)
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            
            if showSnackbar {
                HStack {
                    Text(snackbarMessage)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Button(action: {
                        undoDelete()
                        self.showSnackbar = false
                    }) {
                        Text("Undo")
                            .foregroundColor(.white)
                            .padding([.trailing, .top, .bottom])
                    }
                }
                .background(Color.black.opacity(0.7))
                .cornerRadius(10) 
                .padding()
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut(duration: 0.5))
                .onDisappear {
                    if self.showSnackbar {
                        confirmDeleteNotification()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { _ in }
                        .onEnded { value in
                            if value.translation.height > 50 {
                                // Drop down the snackbar
                                self.showSnackbar = false
                            } else {
                                // Hold the snackbar
                                self.showSnackbar = true
                            }
                        }
                )
            }


        }
        .onAppear {
            if userPreferences.getUser() == nil {
                print("heeeere")
                navigationController.navigate(to: LoginView())
                return
            }
            Task.init(priority: .userInitiated) {
                await loadNotifications()
            }
        }
        .refreshable {
            Task.init(priority: .userInitiated) {
                await loadNotifications()
            }
        }
    }

    
    
    
    
    
    func loadNotifications() async {
        Task {
            viewModel.fetchNotifications() { result in
                switch result {
                case .success(let notificationModel):
                    print("User logged in successfully: \(notificationModel)")
                    if notificationModel.isEmpty {
                        // Load data from Core Data if the API response is empty
                        Task {
                            await fetchNotificationsFromCoreData(context: managedContext) { result in
                                switch result {
                                case .success(let notificationModels):
                                    myList = notificationModels
                                    print("notif list\(myList)")
                                case .failure(let error):
                                    print("Error fetching notifications from Core Data: \(error)")
                                }
                            }
                        }
                    } else {
                        myList = notificationModel
                        
                        for notification in myList {
                            Task {
                                await saveToCoreData(notificationModel: notification, context: managedContext)
                            }
                        }
                    }
                    
                case .failure(let error):
                    if case let UseCaseError.error(message) = error {
                        print("Error logging in: \(message)")
                    } else {
                        print("Error logging in: \(error)")
                    }
                    // Load data from Core Data if there's an error in the API response
                    Task {
                        await fetchNotificationsFromCoreData(context: managedContext) { result in
                            switch result {
                            case .success(let notificationModels):
                                myList = notificationModels
                            case .failure(let error):
                                print("Error fetching notifications from Core Data: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func saveToCoreData(notificationModel: NotificationModel, context: NSManagedObjectContext) async {
        let request: NSFetchRequest<CDNotification> = CDNotification.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", notificationModel.id)
        
        do {
            let existingNotifications = try context.fetch(request)
            if existingNotifications.isEmpty {
                let entity = NSEntityDescription.entity(forEntityName: "CDNotification", in: context)!
                let notificationEntity = NSManagedObject(entity: entity, insertInto: context) as! CDNotification
                notificationEntity.title = notificationModel.title
                notificationEntity.nDescription = notificationModel.description
                notificationEntity.date = Int64(notificationModel.date!)
                notificationEntity.id = notificationModel.id
                
                try await context.save()
            } else {
                print("Notification with the same id already exists")
            }
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }


}









