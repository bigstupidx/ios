//
//  PhotoGalleryDetailTextVC.m
//  Moda
//
//  Created by Zune Moe on 28/11/13.
//  Copyright (c) 2013 Wiz. All rights reserved.
//

#import "PhotoGalleryDetailTextVC.h"

@interface PhotoGalleryDetailTextVC ()
@property (weak, nonatomic) IBOutlet UILabel *photoDetailText;
@end

@implementation PhotoGalleryDetailTextVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.photoDetailText.text = self.detailText;
    self.photoDetailText.text = @"When the user hits the enter key on the keyboard, this method will be called (because earlier you set the view controller up as the delegate of the text field). Here is an explanation of the code: Uses the handy Flickr wrapper class I provided to search Flickr for photos that match the given search term asynchronously. When the search completes, the completion block will be called with a reference to the searched term, the result set of FlickrPhoto objects, and an error (if there was one). Checks to see if you have searched for this term before. If not, the term gets added to the front of the searches array and the results get stashed in the searchResults dictionary, with the key being the search term. At this stage, you have new data and need to refresh the UI. Here the collection view needs to be reloaded to reflect the new data. However, you haven’t yet implemented a collection view, so this is just a placeholder comment for now. Finally, logs any errors to the console. Obviously, in a production application you would want to display these errors to the user. Go ahead and run your app. Perform a search in the text box, and you should see a log message in the console indicating the number of search results, similar to this:";
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
