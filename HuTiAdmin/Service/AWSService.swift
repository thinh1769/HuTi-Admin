//
//  AWSService.swift
//  HuTiAdmin
//
//  Created by Nguyễn Thịnh on 29/04/2023.
//

import Foundation
import AWSS3

class AWSService {
    private lazy var aws = AWSS3.default()
    private var request: AWSS3GetObjectRequest?
    
    init() {
        setupAWSCredential()
        request = AWSS3GetObjectRequest()
    }
    
    private func setupAWSCredential() {
        let accessKey = AWSConstants.accessKey
        let privateKey = AWSConstants.secretKey
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: privateKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.APSoutheast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

    func removeImage(remoteName: String) {
        let deleteRequest = AWSS3DeleteObjectRequest()
        guard let deleteRequest = deleteRequest else { return }
        deleteRequest.bucket = AWSConstants.s3Bucket
        deleteRequest.key = remoteName
        aws.deleteObject(deleteRequest).continueWith { _ in
        }
    }

    func uploadImage(data: AssetDataModel, progressBlock: AWSS3TransferUtilityProgressBlock? = nil, completionHandler: AWSS3TransferUtilityMultiPartUploadCompletionHandlerBlock? = nil) {
        let key = data.remoteName
        let awsUploadExp = AWSS3TransferUtilityMultiPartUploadExpression()
        awsUploadExp.progressBlock = progressBlock
        let transferUtililty  = AWSS3TransferUtility.default()
        
        transferUtililty.uploadUsingMultiPart(data: data.data, bucket: AWSConstants.s3Bucket,
                                              key: key, contentType: data.contentType, expression: awsUploadExp, completionHandler: completionHandler)
        
    }
    
    func cancel() {
        request?.cancel()
    }
}
