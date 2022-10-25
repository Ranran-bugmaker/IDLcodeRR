PRO ex_read_hdf5

  ; Open the HDF5 file.

  file = FILEPATH('hdf5_test.h5', $

    SUBDIRECTORY=['examples', 'data'])

  file_id = H5F_OPEN(file)

  ; Open the image dataset within the file.

  ; This is located within the /images group.

  ; We could also have used H5G_OPEN to open up the group first.

  dataset_id1 = H5D_OPEN(file_id, '/images/Eskimo')



  ; Read in the actual image data.

  image = H5D_READ(dataset_id1)



  ; Open up the dataspace associated with the Eskimo image.

  dataspace_id = H5D_GET_SPACE(dataset_id1)



  ; Retrieve the dimensions so we can set the window size.

  dimensions = H5S_GET_SIMPLE_EXTENT_DIMS(dataspace_id)

  ; Now open and read the color palette associated with

  ; this image.

  dataset_id2 = H5D_OPEN(file_id, '/images/Eskimo_palette')

  palette = H5D_READ(dataset_id2)

  ; Close all our identifiers so we don't leak resources.

  H5S_CLOSE, dataspace_id

  H5D_CLOSE, dataset_id1

  H5D_CLOSE, dataset_id2

  H5F_CLOSE, file_id

  ; Display the data.

  DEVICE, DECOMPOSED=0

  WINDOW, XSIZE=dimensions[0], YSIZE=dimensions[1]

  TVLCT, palette[0,*], palette[1,*], palette[2,*]



  ; Use /ORDER since the image is stored top-to-bottom.

  TV, image, /ORDER

END