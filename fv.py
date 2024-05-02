from PIL import Image
import face_recognition

def calculate_similarity(image_path1, image_path2):
    #Load images
    image1 = face_recognition.load_image_file(image_path1)
    image2 = face_recognition.load_image_file(image_path2)

    #Encode faces in images
    encoding1 = face_recognition.face_encodings(image1)
    encoding2 = face_recognition.face_encodings(image2)

    if not encoding1 or not encoding2:
        return 0  #Return 0 if no face is found in either image

    #Compare images
    is_match = face_recognition.compare_faces([encoding1[0]], encoding2[0])

    if is_match[0]:
        return 100.0  #return 100% similarity for a match
    else:
        return 0.0  #return 0% similarity for no match

if __name__ == "__main__":
    image_path1 = "/Users/samuelchatterton/Documents/FV Test/rg1.jpg"  #Image 1 path
    image_path2 = "/Users/samuelchatterton/Documents/FV Test/rg2.jpg"  #Image 2 path

    similarity = calculate_similarity(image_path1, image_path2)
    print(f"Similarity: {similarity:.2f}%")
