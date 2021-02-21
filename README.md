# MediaResourcesUpload using MultiPart Form-Data

> Uploading media resources such as audio, video and images to a server using Multipart form-data.

## Background Story

Our team were working on an app that required we upload a song and its art onto a DSP server.

This works, as far as I know, using multipart form-data. Our project was setup to use Alamofire.
So, the problem arises as to how to implement this.

We were on this same issue for weeks not been able to resolve the issue of uploading the media to the DSP of choice.

This is the genesis of this project repo.

## The solution

With intensive research I found out the solution. This project is the solution but without the use of Alamofire.

URLSession had to be resorted to and a little idea from the web development(which was actually where I started out).

## Boundaries...

The request has to be sent in form of how the server expects the data to come to it. This can be achieved by constructing
the request body to seem like that of the web.

Hence the introduction of boundaries, which actually is the way it's constructed for the web.

The function below was used to creates a boundary.

```swift
func generateBoundary() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}
```
and the utility below was used to create data body to be appended to the request body. The `append` method on the `Data` type was extendended to be
able to convert a string into a data type for ease of constructing the request body.

```swift

func createDataBody(withParameters parameters: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

```

At this point, the function is not generic enough as you'd notice it will work for an art (photo) alone.
It'll be improved to accommodate any type of the 3 media.

Here's the model that generates the kind of media to be sent...

```swift

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String // MimeType
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        self.data = data
    }
}

```

The way out would be to create an `enum` to hold the different kinds of media (audio, video or image).

Watch out as I improve on this...

Thanks for reading and in aniticipation of a constructive feedback on how make it even better.

Regards.

### Shoutout

A big shout to **![Kilo loco](https://www.kiloloco.com/)** and **![CodeCat15](https://www.youtube.com/c/CodeCat/playlists)** on the invaluable submissions on this guide. I love you guys.
